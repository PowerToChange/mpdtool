require File.dirname(__FILE__) + '/../test_helper'

class ContactsControllerTest < ActionController::TestCase

  def setup
    @request.session[:event_id] = 1
  end

  def test_edit
    @request.session[:user_id] = 1
    get :edit, :id => mpd_users(:lance).mpd_contacts[0].id
    assert_response :success
  end
  
  def test_update
    @request.session[:user_id] = 1
    mpd_contact = mpd_users(:lance).mpd_contacts[0]
    post :update, {:mpd_contact => {:full_name => mpd_contact.full_name}, :id => mpd_contact.id,
                   :mpd_contact_action => {:gift_amount => '1,200'}}
    assert_equal([], assigns(:mpd_contact_action).errors.full_messages)
    assert_response :redirect
  end
  
  def test_update_invalid_contact
    @request.session[:user_id] = 1
    mpd_contact = mpd_users(:lance).mpd_contacts[0]
    post :update, {:mpd_contact => {:full_name => ""},
                   :mpd_contact_action => {:gift_amount => '1,200'}, :id => mpd_contact.id}
    assert_template "edit" 
  end
end
