# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'acts_as_rateable'
class ApplicationController < ActionController::Base
  filter_parameter_logging *FILTER_KEYS
  ActiveRecord::Base.send(:include, Acts::Rateable)
  include HoptoadNotifier::Catcher
  before_filter CASClient::Frameworks::Rails::GatewayFilter unless Rails.env.test?
  
  helper_method :current_mpd_user

  DEFAULT_SORT = "full_name"

  before_filter :check_authentication, :except => [:no_access, :login, :gcx_login, :forgot_password, :send_password_email, :logout, :change_password]
  before_filter :check_authorization, :except => [:no_access, :login, :gcx_login, :forgot_password, :send_password_email, :logout, :change_password]
  
  protected 
  
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
    if session[:cas_extra_attributes]
      @user ||= User.find(:first, :conditions => {_(:guid, :user) => session[:cas_extra_attributes]['ssoGuid']})
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
  
  # Return current user for use in controllers
  def current_mpd_user
    if (!@mpd_user)
      @mpd_user = MpdUser.find_by_user_id(session[:user_id])
    end
    return @mpd_user
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
  
  def process_sort(sort, default_sort=DEFAULT_SORT)
    ret_val = case sort
           when "full_name_reverse" then "full_name DESC"
           when "mpd_contacts.created_at_reverse" then "mpd_contacts.created_at DESC"
           when "letter_sent_reverse" then "letter_sent DESC"
           when "call_made_reverse" then "call_made DESC"
           when "gift_amount_reverse" then "gift_amount DESC"
           when "thankyou_sent_reverse" then "thankyou_sent DESC"
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
      ret_val = ["mpd_contacts.mpd_user_id = ?", current_mpd_user.id]
    else
      ret_val = [conditions + " and mpd_contacts.mpd_user_id = ?", current_mpd_user.id]
    end
    return ret_val
  end
  
  def redirect_back_or_default(default)
    if session[:return_to].nil?
      redirect_to default
    else
      redirect_to_url session[:return_to]
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
end