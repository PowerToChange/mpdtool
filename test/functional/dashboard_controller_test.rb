require File.dirname(__FILE__) + '/../test_helper'
require 'dashboard_controller'

# Re-raise errors caught by the controller.
class DashboardController; def rescue_action(e) raise e end; end

class DashboardControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, User.table_name, Person.table_name, SpApplication.table_name, SpProject.table_name

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
    @request.session[:user_id] = 1
    get :index
    assert_redirected_to :action => "welcome"
  end
  
  def test_show_index
    @request.session[:user_id] = 2
    get :index
    assert_response :success
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
