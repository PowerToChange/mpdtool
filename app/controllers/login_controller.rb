class LoginController < ApplicationController
  before_filter CAS::Filter, :only => :gcx_login
  layout "login"

  def login
    @forgot_password_link = get_forgot_password_link
    
    if request.post? and !params[:user][:username].empty?
      #Authenticate User to generic SSM User
      user = User.authenticate(params[:user][:username], params[:user][:plain_password])
      if user
        #Authenticate User to MPD Tool
        if (!MpdUser.find_by_ssm_id(user.id).nil?)
          session[:user_id] = user.id
          redirect_to :controller => "dashboard",
                      :action => "index"
        else
          flash[:error] = "Your login information was correct, but it appears that you do not have access to use the Ministry Partner Development tool"
        end
      else
        flash[:error] = "Your username or password was invalid"
      end      
    end
  end
  
  def gcx_login
    user = current_mpd_user
    unless user
      redirect_to :controller => "dashboard",
                      :action => "index"
    else
      flash[:error] = "Your login information was correct, but it appears that you do not have access to use the Ministry Partner Development tool"
      render :action => "login"
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have been logged out of the system"
    redirect_to :action => "login"
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
