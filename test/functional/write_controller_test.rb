require File.dirname(__FILE__) + '/../test_helper'
require 'write_controller'

# Re-raise errors caught by the controller.
class WriteController; def rescue_action(e) raise e end; end

class WriteControllerTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_letters, :mpd_letter_templates, :mpd_letter_images, :mpd_contacts, :mpd_expense_types, :mpd_expenses, :simplesecuritymanager_user, :ministry_person, :sp_applications, :sp_projects

  def setup
    @controller = WriteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_show_calculator
    @request.session[:user_id] = simplesecuritymanager_user(:demo1).userID
    get :index
    assert_redirected_to :action => "calculate_support_total"
  end
  
  def test_index_select_template
    @request.session[:user_id] = simplesecuritymanager_user(:demo4).userID
    get :index
    assert_redirected_to :action => "select_template"
  end
  
  def test_index_write_letter
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    get :index
    assert_template 'letter'
  end
  
  def test_select_template
    @request.session[:user_id] = simplesecuritymanager_user(:demo4).userID
    get :select_template, :id => mpd_letter_templates(:single_picture_template).id
    assert_equal mpd_letter_templates(:single_picture_template).id, mpd_users(:demo4).mpd_letter.mpd_letter_template_id    
  end
  
  def test_update_letter
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    post :update_letter, :mpd_letter => {:id => mpd_users(:lance).mpd_letter_id, :update_section => "Update section from test."}    
    assert_equal "Update section from test.", mpd_users(:lance).mpd_letter.update_section
  end
  
  def test_udpate_letter_field_too_long
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    update_section = ""
    1001.times do
      update_section += "x"
    end
    post :update_letter, :mpd_letter => {:id => mpd_users(:lance).mpd_letter_id, :update_section => update_section}
    assert_template "letter"
  end

  def test_calculate_support_total
    @request.session[:user_id] = simplesecuritymanager_user(:lance).userID
    post :calculate_support_total, :mpd_expense => {"1" => {:amount => "100"}, "2" => {:amount => "200"}, "3" => {:amount => "300"}}
  end
end
