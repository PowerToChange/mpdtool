require 'mechanize'
class LoginController < ApplicationController
  layout "login"

  def login
    cas_url = 'https://thekey.me/cas/login.htm?template=https://d15ip9v2bx8xzx.cloudfront.net/media/sso/p2c_style.css'
    @gcx_service_url = cas_url + '&service=' + url_for(:action => :login)

    @forgot_password_link = get_forgot_password_link
    if request.post? and !params[:username].empty?
      #Authenticate User to generic SSM User
      user = User.authenticate(params[:username], params[:password])
      unless user
        # Try CAS
        form_params = {:username => params[:username], :password => params[:password], :service => url_for('/') }
        agent = WWW::Mechanize.new
        agent.keep_alive = false
        page = agent.post(cas_url, form_params)
        result_query = page.uri.query
        unless result_query && result_query.include?('BadPassword')
          redirect_to(cas_url + '?service=' + url_for(:action => :login) + '&username=' + params[:username] + '&password=' + params[:password])
        end
      end
      flash[:error] = "Your username or password was invalid" unless user
    else
      user = get_user_from_cas
    end
    if user
      #Authenticate User to MPD Tool
      # if (MpdUser.has_access(user))
      # Create an mpd user if one doesn't exist
      MpdUser.create!(:user_id => user.id) unless MpdUser.find(:first, :conditions => {_(:user_id, :mpd_user) => user.id})

      # Reset session (in case last user didn't log out)
      session[:user_id] = nil
      session[:event_id] = nil
      session[:cas_user] = nil

      session[:user_id] = user.id
      redirect_to :controller => "dashboard",
                    :action => "index"
      # else
        # flash[:error] = "Your login information was correct, but it appears that you do not have access to use the Ministry Partner Development tool"
      # end
    end      
  end
  
  def signup
    @user = User.new(params[:user])
    @person = Person.new(params[:person])
    return unless request.post?
    @user.valid?
    if @person.firstName.to_s.strip.empty? || @person.lastName.to_s.strip.empty?
      @user.errors.add_to_base "Please enter your first and last name."
      @person.errors.add(:firstName, "can't be blank.") if @person.firstName.to_s.empty?
      @person.errors.add(:lastName, "can't be blank.") if @person.lastName.to_s.empty?
    end
    unless @user.errors.empty?
      render :action => 'signup'
    else
      @user.save
      @person = @user.create_person_and_address(params[:person])
      redirect_back_or_default(:action => 'login')
      flash[:notice] = "Thanks for signing up!"
    end
  end
  
  def gcx_login
    user = current_mpd_user
    unless user
      redirect_to :controller => "dashboard",
                      :action => "index"
    else
      #flash[:error] = "Your login information was correct, but it appears that you do not have access to use the Ministry Partner Development tool"
      render :action => "login"
    end
  end
  
  def logout
    session[:user_id] = nil
    session[:event_id] = nil
    session[:cas_user] = nil
    flash[:notice] = "You have been logged out of the system"
    CASClient::Frameworks::Rails::Filter.logout(self, login_url)
  end
  
  private 
  def get_domain
    port = request.env['SERVER_PORT']
    port = (port.nil? || port == "80" || port == "443") ? "" : ":" + port.to_s
    
    protocol = request.env['SERVER_PORT_SECURE']
    protocol = (protocol.nil? || protocol == "0") ? "http://" : "https://"
    
    server_name = request.env['SERVER_NAME']
    server_name ||= ""
    
    domain = protocol + server_name + port
  end
  
  def get_forgot_password_link
    link = "https://staff.campuscrusadeforchrist.com/servlet/AccountController?action=goToPage&page=lookupQuestion&loginPage=" + request.protocol + request.host_with_port
  end
end
