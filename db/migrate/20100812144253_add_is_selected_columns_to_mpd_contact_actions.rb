class AddIsSelectedColumnsToMpdContactActions < ActiveRecord::Migration
  def self.up
    add_column(:mpd_contact_actions, :is_selected_letter, :boolean)
    add_column(:mpd_contact_actions, :is_selected_call, :boolean)
    add_column(:mpd_contact_actions, :is_selected_thankyou, :boolean)
  end

  def self.down
    remove_column(:mpd_contact_actions, :is_selected_letter)
    remove_column(:mpd_contact_actions, :is_selected_call)
    remove_column(:mpd_contact_actions, :is_selected_thankyou)
  end
end
