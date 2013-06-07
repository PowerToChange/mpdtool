require File.dirname(__FILE__) + '/../test_helper'
class AddressesControllerTest < ActionController::TestCase

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
