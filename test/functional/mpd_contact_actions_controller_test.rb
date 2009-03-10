require File.dirname(__FILE__) + '/../test_helper'

class MpdContactActionsControllerTest < ActionController::TestCase
  fixtures :mpd_contact_actions
  def setup
    @request.session[:user_id] = 2
  end
  
#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:mpd_contact_actions)
#  end

#  test "should get new" do
#    get :new
#    assert_response :success
#  end

#  test "should create mpd_contact_action" do
#    assert_difference('MpdContactAction.count') do
#      post :create, :mpd_contact_action => {:event_id => 1, :mpd_contact_id => 1 }
#    end

#    assert_redirected_to mpd_contact_action_path(assigns(:mpd_contact_action))
#  end

  test "should show mpd_contact_action" do
    get :show, :id => 1
    assert_redirected_to edit_contact_path(MpdContactAction.find(1).mpd_contact)
  end

#  test "should get edit" do
#    get :edit, :id => 1
#    assert_response :success
#  end

#  test "should update mpd_contact_action" do
#    put :update, :id => 1, :mpd_contact_action => { }
#    assert_redirected_to mpd_contact_action_path(assigns(:mpd_contact_action))
#  end

  test "should destroy mpd_contact_action" do
    assert_difference('MpdContactAction.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to :controller => :dashboard
  end
end
