require File.dirname(__FILE__) + '/../test_helper'
require 'addresses_controller'

# Re-raise errors caught by the controller.
class AddressesController; def rescue_action(e) raise e end; end

class AddressesControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, :simplesecuritymanager_user, :ministry_person, :sp_applications, :sp_projects

  def setup
    @controller = AddressesController.new
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
end
