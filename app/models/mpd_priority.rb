class MpdPriority < ActiveRecord::Base
  belongs_to :rateable, :polymorphic => true
  
  # NOTE: Comments belong to a user
  belongs_to :mpd_user
  
  # Helper class method to lookup all priorities assigned
  # to all rateable types for a given user.
  def self.find_priorities_by_mpd_user(mpd_user)
    find(:all,
         :conditions => ["mpd_user_id = ?", mpd_user.id],
         :order => "created_at DESC"
    )
  end
end
