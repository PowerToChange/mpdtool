require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end


class LoginControllerTest < Test::Unit::TestCase
  fixtures User.table_name

  def setup
    @controller = LoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # def test_login
  #   lance = User.find(1)
  #   post :login, :user => {:username => "lance.leonard@evermindmedia.com", :plain_password => "Password"}
  #   assert_redirected_to :controller => "dashboard", :action => "index"
  #   assert_equal lance.user_id, session[:user_id]
  # end

  def test_failed_login
    post :login, :user => {:username => "notauser", :plain_password => "WrongPassword"}
    assert_equal "Your username or password was invalid", flash[:error]
  end
  
  def test_logout
    get :logout
    assert_redirected_to :action => "login"
  end
  
  def test_forgot_password
    get :forgot_password
    
  end
end
