# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'acts_as_rateable'
class ApplicationController < ActionController::Base
  filter_parameter_logging *FILTER_KEYS
  ActiveRecord::Base.send(:include, Acts::Rateable)
#  include HoptoadNotifier::Catcher
  include ExceptionNotifiable #Automatically generates emails of errors
  before_filter CASClient::Frameworks::Rails::GatewayFilter unless Rails.env.test?
  
  helper_method :current_mpd_user, :current_user, :current_person, :current_event

  DEFAULT_SORT = "full_name"

  before_filter :check_authentication, :except => [:no_access, :login, :gcx_login, :forgot_password, :send_password_email, :logout, :change_password]
  before_filter :check_authorization, :except => [:no_access, :login, :gcx_login, :forgot_password, :send_password_email, :logout, :change_password]
  
  protected 
  
  def current_event
    @current_event = MpdEvent.find(session[:event_id]) if session[:event_id]
    # If they have a current summer project app, see if we've already created an event for it
    if !@current_event && current_person.current_application && current_person.current_application.project
      @current_event = current_mpd_user.mpd_events.find_by_project_id(current_person.current_application.project.id)
      # if the current event is also a project, check for an update to the event cost
      if @current_event && @current_event.cost != current_person.current_application.project_cost
        @current_event.update_attribute(:cost, current_person.current_application.project_cost)
      end
      unless @current_event
        # Create an event and set it to active
        @current_event = current_mpd_user.mpd_events.create(:project_id => current_person.current_application.project.id, 
                                                            :name => current_person.current_application.project.name,
                                                            :start_date => current_person.current_application.project.start_date,
                                                            :cost => current_person.current_application.project_cost)
      end
    end
    unless @current_event
      # See if they have a last event stored
      @current_event = MpdEvent.find_by_id(current_mpd_user.current_event_id) if current_mpd_user.current_event_id
      # Get the first event on their list
      @current_event ||= current_mpd_user.mpd_events.first
      # If we still don't have an event, we need to create a default one.
      @current_event ||= current_mpd_user.mpd_events.create(:name => 'Unnamed Event',
                                         :start_date => Date.today)
    end
    current_mpd_user.update_attribute(:current_event_id, @current_event.id) unless current_mpd_user.current_event_id == @current_event.id
    session[:event_id] = @current_event.id
    @current_event 
  end
  
  def current_person
    raise current_user.inspect unless current_user.person
    @current_person ||= current_user.person
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id])
  end
  
  # Return current user for use in controllers
  def current_mpd_user
    @mpd_user ||= MpdUser.find(:first, :conditions => {_(:user_id, :mpd_user) => session[:user_id]})
  end
  
  def check_authentication
    unless session[:user_id]
      get_user_from_cas
      unless session[:user_id]
        flash[:notice] = "Please log in"
        redirect_to :controller => "login", :action => "login"
        return false
      end
    end
  end
  
  def get_user_from_cas
    if session[:cas_user] && session[:cas_extra_attributes]
      @user ||= User.find(:first, :conditions => {_(:guid, :user) => session[:cas_extra_attributes]['ssoGuid']})
      # allow User implementations to make a new user at this point
      if @user.nil? && User.respond_to?(:create_new_user_from_cas)
        @user = User.create_new_user_from_cas(session[:cas_user], session[:cas_extra_attributes])
      end
      session[:user_id] = @user.id if @user
    end
    return @user
  end
  
  def check_authorization
    unless current_mpd_user
      flash[:error] = "Your login information was correct, but it appears that you do not have access to use the Ministry Partner Development tool"
      redirect_to :controller => "login", :action => "login"
      return false
    end
  end
  
  # Paginate a collection of prefetched data
  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options

    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
  
  def process_sort(sort, default_sort = DEFAULT_SORT)
    ret_val = case sort
           when "full_name_reverse" then "full_name DESC"
           when "mpd_contacts.created_at_reverse" then "mpd_contacts.created_at DESC"
           when "letter_sent_reverse" then "mpd_contact_actions.letter_sent DESC"
           when "call_made_reverse" then "mpd_contact_actions.call_made DESC"
           when "gift_amount_reverse" then "mpd_contact_actions.gift_amount DESC"
           when "thankyou_sent_reverse" then "mpd_contact_actions.thankyou_sent DESC"
           when "mpd_priorities.priority_reverse" then "mpd_priorities.priority DESC"
           when "address_1_reverse" then "address_1 DESC"
           when "phone_reverse" then "phone DESC"
           else params['sort']
           end
    ret_val = default_sort if ret_val.nil?
    return ret_val
  end
  
  def process_conditions(conditions = nil)
    if conditions.nil?
      ret_val = ["mpd_contacts.mpd_user_id = ? AND mpd_contact_actions.event_id = ?", current_mpd_user.id, current_event.id]
    else
      ret_val = [conditions + " and mpd_contacts.mpd_user_id = ? AND mpd_contact_actions.event_id = ?", current_mpd_user.id, current_event.id]
    end
    return ret_val
  end
  
  def redirect_back_or_default(default)
    if session[:return_to].nil?
      redirect_to default
    else
      redirect_to session[:return_to]
      session[:return_to] = nil
    end
  end

  def render_to_pdf(options = nil)
    data = render_to_string(options)
    pdf = PDF::HTMLDoc.new
    pdf.set_option :bodycolor, :white
    pdf.set_option :toc, false
    pdf.set_option :portrait, true
    pdf.set_option :links, false
    pdf.set_option :webpage, true
    pdf.set_option :left, '2cm'
    pdf.set_option :right, '2cm'
    pdf << data
    pdf.generate
  end
  
  def _(column, table)
    ActiveRecord::Base._(column, table)
  end
  
  def self.application_name
    'MPD'
  end
end
