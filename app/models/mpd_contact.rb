class MpdContact < ActiveRecord::Base
  acts_as_rateable
  
  belongs_to :mpd_user
  belongs_to :mpd_priority
  
  validates_presence_of :full_name
  validates_presence_of :salutation, :on => :update, :message => "can't be blank"
  validates_numericality_of :gift_amount, :if => Proc.new { |c| !c.gift_amount.blank? }
  validates_format_of :phone, :with => /^(\(?[0-9]{3}[\)-\.]?\ ?)?[0-9]{3}[-\.]?[0-9]{4}$/,
                              :if => Proc.new { |c| !c.phone.blank? }
  validates_format_of :email_address, :with => /^[a-z0-9!$'*+\-_]+(\.[a-z0-9!$'*+\-_]+)*@([a-z0-9]+(-+[a-z0-9]+)*\.)+([a-z]{2}|aero|arpa|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|travel)$/,
                                      :if => Proc.new { |c| !c.email_address.blank? }
  validates_format_of :zip, :with => /^[0-9]{5}([\s-]{1}[0-9]{4})?$/,
                            :if => Proc.new { |c| !c.zip.blank? }  
  before_create :set_salutation                                    

  def display_address(lb = false)
    ret_val = ""
    if !self.address_1.nil? and !self.address_1.empty?
      ret_val += address_1
      if lb 
        ret_val += "<br/>"
      else 
        ret_val += ", "
      end 
      ret_val += city + ", " + state + " " + zip
    else 
      ret_val = nil
    end
    return ret_val
  end
  
  def make_call!
    self.update_attribute(:call_made, true)
  end
  
  def salutation
    self[:salutation] || self.full_name
  end

  protected
  def validate
    errors.add(:gift_amount, "should be at least 1") if !gift_amount.nil? && !gift_amount.blank? && gift_amount < 1
  end
  
  def set_salutation
    self.salutation = self.full_name
  end
end
