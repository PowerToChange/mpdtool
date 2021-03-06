require File.dirname(__FILE__) + '/../test_helper'
class CallControllerTest < ActionController::TestCase

  def test_index
    @request.session[:user_id] = 1
    get :index
    assert_response :success
  end
  
  def test_sort
    @request.session[:user_id] = 1
    xhr(:get, :index, :sort => 'address_1')
  end

  def test_complete_call
    @request.session[:event_id] = 1
    @request.session[:user_id] = 1
    count = mpd_users(:lance).mpd_contacts_to_call(1).size
    xhr(:post, :complete, :id => mpd_users(:lance).mpd_contacts_to_call(1).first.id)
    assert assigns(:mpd_contact)
    assert_equal count - 1, mpd_users(:lance).mpd_contacts_to_call(1).size
  end
  
  def test_toggle_show_follow_up_help
    @request.session[:user_id] = 1
    show = mpd_users(:lance).show_follow_up_help
    xhr(:post, :toggle_show_follow_up_help)
#    assert_equal !show, mpd_users(:lance).show_follow_up_help    
  end
end
