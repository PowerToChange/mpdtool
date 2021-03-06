class AddEditableTableFields < ActiveRecord::Migration
  def self.up
    add_column(:mpd_contact_actions, :postproject_sent, :boolean, :default => false)
    add_column(:mpd_contact_actions, :partner_financial, :boolean, :default => false)
    add_column(:mpd_contact_actions, :partner_prayer, :boolean, :default => false)
    add_column(:mpd_contact_actions, :gift_pledged, :boolean, :default => false)
    add_column(:mpd_contact_actions, :gift_received, :boolean, :default => false)    
    add_column(:mpd_contact_actions, :date_received, :string)
    add_column(:mpd_contact_actions, :form_received, :string, :default => "Not Received" )
    add_column(:mpd_contacts, :phone_2, :string, :limit => 25, :default => '')
    add_column(:mpd_contacts, :relationship, :string, :default => '')
    change_column(:mpd_contacts, :address_1, :string, :default => '')
    change_column(:mpd_contacts, :city, :string, :default => '')
    change_column(:mpd_contacts, :state, :string, :default => '')
    change_column(:mpd_contacts, :zip, :string, :default => '')
    change_column(:mpd_contacts, :phone, :string, :default => '')
    change_column(:mpd_contacts, :email_address, :string, :default => '')
    change_column(:mpd_contacts, :address_1, :string, :default => '')
    rename_column(:mpd_contact_actions, :call_made, :contacted)
  end

  def self.down
    remove_column(:mpd_contact_actions, :postproject_sent)
    remove_column(:mpd_contact_actions, :partner_financial)
    remove_column(:mpd_contact_actions, :partner_prayer)
    remove_column(:mpd_contact_actions, :gift_pledged)
    remove_column(:mpd_contact_actions, :gift_received)
    remove_column(:mpd_contact_actions, :date_received)
    remove_column(:mpd_contact_actions, :form_received)
    remove_column(:mpd_contacts, :phone_2)
    remove_column(:mpd_contacts, :relationship)
    change_column(:mpd_contacts, :address_1,:default => nil)
    change_column(:mpd_contacts, :city,:default => nil)
    change_column(:mpd_contacts, :state,:default => nil)
    change_column(:mpd_contacts, :zip,:default => nil)
    change_column(:mpd_contacts, :phone,:default => nil)
    change_column(:mpd_contacts, :email_address,:default => nil)
    change_column(:mpd_contacts, :address_1,:default => nil)
    rename_column(:mpd_contact_actions, :contacted, :call_made)
  end
end
