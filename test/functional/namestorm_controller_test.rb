require File.dirname(__FILE__) + '/../test_helper'
require 'namestorm_controller'

# Re-raise errors caught by the controller.
class NamestormController; def rescue_action(e) raise e end; end

class NamestormControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, :simplesecuritymanager_user, :ministry_person, :sp_applications, :sp_projects

  def setup
    @controller = NamestormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_get_index_with_new_user
    @request.session[:user_id] = simplesecuritymanager_user(:demo1).userID
    get :index
    assert_redirected_to :action => 'start'
  end
  
  def test_get_index
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    get :index
    assert_redirected_to :action => 'list'
  end
  
  def test_start_add_one_contact
    @request.session[:user_id] = simplesecuritymanager_user(:demo1).userID
    post :start, :contacts => ["New Contact 1", "New Contact Two"]
    assert_equal 2, mpd_users(:demo1).mpd_contacts.size
  end
  
  def test_start_add_0_contacts
    @request.session[:user_id] = simplesecuritymanager_user(:demo1).userID
    post :start, :contacts => []
    assert_equal "Try adding some names this time!", flash[:error]
  end
  
  def test_list
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    get :list
    assert_response :success
  end
  
  def test_add
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    count = mpd_users(:lance).mpd_contacts.size
    xhr(:post, :add, :full_name => "New Contact")
    assert_equal count+1, mpd_users(:lance).mpd_contacts.size
  end
end
