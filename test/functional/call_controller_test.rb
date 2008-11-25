require File.dirname(__FILE__) + '/../test_helper'
require 'call_controller'

# Re-raise errors caught by the controller.
class CallController; def rescue_action(e) raise e end; end

class CallControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, :simplesecuritymanager_user, :ministry_person, :sp_applications, :sp_projects

  def setup
    @controller = CallController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    get :index
    assert_response :success
  end
  
  def test_sort
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    xhr(:get, :index, :sort => 'address_1')
  end

  def test_complete_call
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    count = mpd_users(:lance).mpd_contacts_to_call.size
    xhr(:post, :complete, :id => mpd_users(:lance).mpd_contacts_to_call.first.id)
    assert assigns(:mpd_contact)
    assert_equal count - 1, mpd_users(:lance).mpd_contacts_to_call.size
  end
  
  def test_toggle_show_follow_up_help
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    show = mpd_users(:lance).show_follow_up_help
    xhr(:post, :toggle_show_follow_up_help)
#    assert_equal !show, mpd_users(:lance).show_follow_up_help    
  end
end
