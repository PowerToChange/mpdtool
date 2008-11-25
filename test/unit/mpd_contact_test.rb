require File.dirname(__FILE__) + '/../test_helper'

class MpdContactTest < Test::Unit::TestCase
  fixtures :mpd_contacts

  def test_invalid_with_empty_attributes
    mpd_contact = MpdContact.new
    assert !mpd_contact.valid?
    assert mpd_contact.errors.invalid?(:full_name)
  end
  
  def test_positive_gift_amount
    mpd_contact = MpdContact.new(:full_name => "Roger Nord")

    mpd_contact.gift_amount = -1
    assert !mpd_contact.valid?
    assert_equal "should be at least 1", mpd_contact.errors.on(:gift_amount)
    
    mpd_contact.gift_amount = 0
    assert !mpd_contact.valid?
    assert_equal "should be at least 1", mpd_contact.errors.on(:gift_amount)
    
    mpd_contact.gift_amount = 1
    assert mpd_contact.valid?
  end
  
  def test_display_address
    sherry = mpd_contacts(:sherry_leonard)
    maria = mpd_contacts(:maria_miller)
    
    sherry_flat_address = "sherry address 1, sherry city, MO 12345"
    sherry_address_with_lb = "sherry address 1<br/>sherry city, MO 12345"
    
    assert_equal sherry_flat_address, sherry.display_address
    
    assert_equal sherry_address_with_lb, sherry.display_address(true)
    
    assert_nil maria.display_address
  end
  
  def test_make_call
    roger = MpdContact.new(:full_name => "Roger Nord")
    roger.make_call!
    
    assert_equal true, roger.call_made
  end
end
