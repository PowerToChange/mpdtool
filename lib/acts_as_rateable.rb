# ActsAsRateable
  module Acts #:nodoc:
    module Rateable #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_rateable
          has_many :mpd_priorities, :as => :rateable, :dependent => :destroy
          include Acts::Rateable::InstanceMethods
          extend Acts::Rateable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        # Helper method to lookup for ratings for a given object.
        # This method is equivalent to obj.ratings
        def find_mpd_priorities_for(obj)
          rateable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
         
          MpdPriority.find(:all,
            :conditions => ["rateable_id = ? and rateable_type = ?", obj.id, rateable],
            :order => "created_at DESC"
          )
        end
        
        # Helper class method to lookup ratings for
        # the mixin rateable type written by a given user.  
        # This method is NOT equivalent to Rating.find_ratings_for_user
        def find_mpd_priorities_by_mpd_user(mpd_user) 
          rateable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          
          MpdPriority.find(:all,
            :conditions => ["mpd_user_id = ? and rateable_type = ?", mpd_user.id, rateable],
            :order => "created_at DESC"
          )
        end
        
        # Helper class method to lookup rateable instances
        # with a given rating.
        def find_by_priority(priority)
          rateable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          mpd_priorities = MpdRating.find(:all,
            :conditions => ["priority = ? and rateable_type = ?", priority, rateable],
            :order => "created_at DESC"
          )
          rateables = []
          mpd_priorities.each { |r|
            rateables << r.rateable
          }
          rateables.uniq!
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        # Helper method that defaults the current time to the submitted field.
        def add_priority(priority)
          mpd_priorities << priority
        end
        
        # Helper method that returns the average rating
        # 
        def priority
          average = 0.0
          mpd_priorities.each { |p|
            average = average + p.priority
          }
          if mpd_priorities.size != 0
            average = average / mpd_priorities.size 
          end
          average
        end
        
        # Check to see if a user already rated this rateable
        def prioritized_by_mpd_user?(mpd_user)
          rtn = false
          if mpd_user
            self.mpd_priorities.each { |b|
              rtn = true if mpd_user.id == b.mpd_user_id
            }
          end
          rtn
        end
      end
    end
  end
