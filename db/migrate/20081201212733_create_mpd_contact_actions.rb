class CreateMpdContactActions < ActiveRecord::Migration
  def self.up
    create_table :mpd_contact_actions do |t|
      t.integer :mpd_contact_id, :event_id
      t.float    "gift_amount"
      t.boolean  "letter_sent",                   :default => false
      t.boolean  "call_made",                     :default => false
      t.boolean  "thankyou_sent",                 :default => false
      t.timestamps
    end
    add_index :mpd_contact_actions, [:mpd_contact_id, :event_id], :unique => true
    
    # Migrate data over from single-year table
    contacts = MpdContact.find(:all, :include => :mpd_user)
    contacts.each do |contact|
      @project = contact.mpd_user.get_project if contact.mpd_user
      if @project
        action = MpdContactAction.find(:first, :conditions => {:event_id => @project.id, :mpd_contact_id => contact.id})
        MpdContactAction.create(:mpd_contact_id => contact.id, :event_id => @project.id, :gift_amount => contact.gift_amount, 
                                :letter_sent => contact.letter_sent, :call_made => contact.call_made, 
                                :thankyou_sent => contact.thankyou_sent) unless action
      end
    end
    remove_column :mpd_contacts, :gift_amount
    remove_column :mpd_contacts, :letter_sent
    remove_column :mpd_contacts, :call_made
    remove_column :mpd_contacts, :thankyou_sent
  end

  def self.down
    remove_index :mpd_contact_actions, :column => [:mpd_contact_id, :event_id]
    add_column :mpd_contacts, :thankyou_sent, :boolean,  :default => false
    add_column :mpd_contacts, :call_made, :boolean,      :default => false
    add_column :mpd_contacts, :letter_sent, :boolean,    :default => false
    add_column :mpd_contacts, :gift_amount, :float
    drop_table :mpd_contact_actions
  end
end
