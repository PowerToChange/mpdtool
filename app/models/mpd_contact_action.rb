class MpdContactAction < ActiveRecord::Base
  belongs_to :mpd_contact
  belongs_to :mpd_event, :class_name => "MpdEvent", :foreign_key => "event_id"
  validates_presence_of :event_id, :mpd_contact_id
  
  protected
end
