class MultipleMpdLettersPerUser < ActiveRecord::Migration
  class MpdUser < ActiveRecord::Base; end
  class MpdLetter < ActiveRecord::Base; end
  class MpdEvent < ActiveRecord::Base; end
    
  def self.up
    #since users will now have multiple letters, change from users having letter ID's to letters having user ID's
    add_column(:mpd_letters, :mpd_user_id, :integer, :after => :id)
    add_column(:mpd_letters, :name, :string) #add a name for each letter
    add_column(:mpd_events, :current_letter, :integer) #remember which letter is currently selected
    MpdUser.find(:all).each do |user|
      if (user.mpd_letter_id != nil)
        @letter = MpdLetter.find(user.mpd_letter_id)
        @letter.update_attribute(:mpd_user_id, user.id) #give letters their user's ID
        if user.current_event_id
          @event = MpdEvent.find(user.current_event_id)
          @letter.update_attribute(:name, @event.name) #name letters after their user's current event
          @event.update_attribute(:current_letter, @letter.id) #give events a selected letter
        else
          @letter.update_attribute(:name, "Unnamed letter") #in the odd chance that an old user will come back, have their letter named
        end
      end
    end
    add_index "mpd_letters", ["mpd_user_id"], :name => "mpd_letters_mpd_user_id_index"
    remove_index "mpd_users", :name => "mpd_users_mpd_letter_id_index"
    remove_column(:mpd_users, :mpd_letter_id)
  end

  def self.down
    add_column(:mpd_users, :mpd_letter_id, :integer, :after => :user_id)
    
    MpdLetter.find(:all).each do |letter|
      if (letter.mpd_user_id != nil) #some letters are orphans
        @user = MpdUser.find(letter.mpd_user_id)
        if @user.current_event_id
          @event = MpdEvent.find(@user.current_event_id)
          @user.update_attribute(:mpd_letter_id, @event.current_letter)
        else
          @user.update_attribute(:mpd_letter_id, letter.id)
        end
      end
    end
    
    add_index "mpd_users", ["mpd_letter_id"], :name => "mpd_users_mpd_letter_id_index"
    remove_column(:mpd_letters, :mpd_user_id)
    remove_column(:mpd_letters, :name)
    remove_column(:mpd_events, :current_letter)
  end
end
