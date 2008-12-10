require File.dirname(__FILE__) + '/../test_helper'
require 'addresses_controller'

# Re-raise errors caught by the controller.
class AddressesController; def rescue_action(e) raise e end; end

class AddressesControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, User.table_name, Person.table_name, SpApplication.table_name, 
            SpProject.table_name#, :cim_hrdb_access

  def setup
    @controller = AddressesController.new
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
end
