class MpdUser < ActiveRecord::Base
  has_many :mpd_events
end
class MpdEvent < ActiveRecord::Base; end
class MpdExpense < ActiveRecord::Base
  belongs_to :mpd_user
  belongs_to :mpd_event
end

class TieExpensesToEvent < ActiveRecord::Migration
  def self.up
    expenses = MpdExpense.find(:all, :conditions => "mpd_event_id is null")
    expenses.each do |e|
      event = e.mpd_user.mpd_events.first
      e.update_attribute(:mpd_event_id, event.id) if event
    end
  end

  def self.down
  end
end
