require File.dirname(__FILE__) + '/../test_helper'

class LoginControllerTest < ActionController::TestCase

  # def test_login
  #   lance = User.find(1)
  #   post :login, :user => {:username => "lance.leonard@evermindmedia.com", :plain_password => "Password"}
  #   assert_redirected_to :controller => "dashboard", :action => "index"
  #   assert_equal lance.user_id, session[:user_id]
  # end

  def test_failed_login
    post :login, :username => "notauser", :password => "WrongPassword"
    assert_equal "Your username or password was invalid", flash[:error]
  end
  
  def test_logout
    get :logout
    assert_response :redirect
  end
  
  def test_forgot_password
    get :forgot_password
    assert_response :success, @response.body
  end
end
