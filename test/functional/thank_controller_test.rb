require File.dirname(__FILE__) + '/../test_helper'

class ThankControllerTest < ActionController::TestCase

  def test_index
    @request.session[:user_id] = 1
    get :index
    assert_response :success
  end
  
  def test_sort
    @request.session[:user_id] = 1
    xhr(:get, :index, :sort => 'address_1')
  end

  def test_toggle_show_follow_up_help
    @request.session[:user_id] = 1
    show = mpd_users(:lance).show_thank_help
    xhr(:post, :toggle_show_thank_help)
#    assert_equal !show, mpd_users(:lance).show_thank_help    
  end
end
