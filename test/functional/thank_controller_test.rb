require File.dirname(__FILE__) + '/../test_helper'
require 'thank_controller'

# Re-raise errors caught by the controller.
class ThankController; def rescue_action(e) raise e end; end

class ThankControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, User.table_name, Person.table_name, SpApplication.table_name, SpProject.table_name

  def setup
    @controller = ThankController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

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
