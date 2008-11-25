require File.dirname(__FILE__) + '/../test_helper'
require 'dashboard_controller'

# Re-raise errors caught by the controller.
class DashboardController; def rescue_action(e) raise e end; end

class DashboardControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, :simplesecuritymanager_user, :ministry_person, :sp_applications, :sp_projects

  def setup
    @controller = DashboardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_without_user
    get :index
    assert_redirected_to :controller => "login", :action => "login"
    assert_equal "Please log in", flash[:notice]
  end
  
  def test_show_welcome
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    get :index
    assert_redirected_to :action => "welcome"
  end
  
  def test_show_index
    @request.session[:user_id] = simplesecuritymanager_user(:demo1).userID
    get :index
    assert_response :success
  end
  
  def test_sort
    @request.session[:user_id] = simplesecuritymanager_user(:demo1).userID
    xhr(:get, :index, :sort => 'letter_sent')
  end
  
  def test_get_started
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    get :get_started
    assert_redirected_to :action => "index"
  end
  
  def test_welcome
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    get :welcome
    assert_response :success
  end
  
end
