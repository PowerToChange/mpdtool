class MpdContactAction < ActiveRecord::Base
  belongs_to :mpd_contact
  belongs_to :mpd_event, :class_name => "MpdEvent", :foreign_key => "event_id"
  validates_presence_of :event_id, :mpd_contact_id
  validates_numericality_of :gift_amount, :if => Proc.new { |c| !c.gift_amount.blank? }
  
  protected
  def validate
    errors.add(:gift_amount, "should be at least 1") if !gift_amount.nil? && !gift_amount.blank? && gift_amount < 1
  end
end
