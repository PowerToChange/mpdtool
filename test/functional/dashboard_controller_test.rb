require File.dirname(__FILE__) + '/../test_helper'

class DashboardControllerTest < ActionController::TestCase

  def test_index_without_user
    get :index
    assert_redirected_to :controller => "login", :action => "login"
    assert_equal "Please log in", flash[:notice]
  end
  
  def test_show_welcome
    @request.session[:user_id] = 3
    get :index
    assert_redirected_to :action => "welcome"
  end
  
  def test_show_index_no_project
    @request.session[:user_id] = 2
    get :index
    assert_response :success
  end
  
  def test_show_index_with_project
    @request.session[:user_id] = 1
    get :index
    assert_response :success, @response.body
  end
  
  def test_sort
    @request.session[:user_id] = 2
    xhr(:get, :index, :sort => 'letter_sent')
  end
  
  def test_get_started
    @request.session[:user_id] = 1
    get :get_started
    assert_redirected_to :action => "index"
  end
  
  def test_welcome
    @request.session[:user_id] = 1
    get :welcome
    assert_response :success
  end
  
end
