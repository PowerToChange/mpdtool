require File.dirname(__FILE__) + '/../test_helper'

class MpdUserTest < Test::Unit::TestCase
  fixtures :mpd_users, :mpd_contacts, :mpd_expense_types, :mpd_expenses, User.table_name, Person.table_name, SpApplication.table_name, SpProject.table_name

  def test_no_user_id
    mpd_user = MpdUser.new
    assert !mpd_user.valid?
    assert mpd_user.errors.invalid?(:user_id)
  end
  
  def test_contacts_to_call
    lance = mpd_users(:lance)
    assert_equal 15, lance.mpd_contacts_to_call.size
  end
  
  def test_contacts_to_thank
    lance = mpd_users(:lance)
    assert_equal 20, lance.mpd_contacts_to_thank.size
  end
  
  def test_create_expenses_for_user
    mpd_user = MpdUser.create!(:user_id => 400)
    assert_equal 3, mpd_user.mpd_expenses.size
  end
  
  def test_support_total
    lance = mpd_users(:lance)
    assert_equal 5000, lance.support_total
  end
  
  def test_start_date
    lance = mpd_users(:lance)
    start_date = Time.local(2007,6,1)
    assert_equal start_date, lance.project_start_date
  end
  
  def test_project_cost
    lance = mpd_users(:lance)
    assert_equal 2000, lance.project_cost
  end
  
  def test_app_accepted_date
    lance = mpd_users(:lance)
    accepted_date = Time.local(2007,1,1)
    assert_equal accepted_date, lance.app_accepted_date
  end
end
