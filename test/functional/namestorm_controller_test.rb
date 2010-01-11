require File.dirname(__FILE__) + '/../test_helper'

class NamestormControllerTest < ActionController::TestCase

  def test_get_index_with_new_user
    @request.session[:user_id] = 2
    get :index
    assert_redirected_to :action => 'start'
  end
  
  def test_get_index
    @request.session[:user_id] = 1
    get :index
    assert_redirected_to :action => 'list'
  end
  
  def test_start_add_one_contact
    @request.session[:user_id] = 2
    post :start, :contacts => ["New Contact 1", "New Contact Two"]
    assert_equal 2, mpd_users(:demo1).mpd_contacts.size
  end
  
  def test_start_add_0_contacts
    @request.session[:user_id] = 2
    post :start, :contacts => []
    assert_equal "Try adding some names this time!", flash[:error]
  end
  
  def test_list
    @request.session[:user_id] = 1
    get :list
    assert_response :success
  end
  
  def test_add
    @request.session[:user_id] = 1
    count = mpd_users(:lance).mpd_contacts.size
    xhr(:post, :add, :full_name => "New Contact")
    assert_equal count+1, mpd_users(:lance).mpd_contacts.size
  end
end
