class CreateMpdEvents < ActiveRecord::Migration
  def self.up
    create_table :mpd_events do |t|
      t.string :name
      t.date :start_date
      t.integer :cost, :mpd_user_id, :project_id
      t.timestamps
    end
    add_column :mpd_users, :current_event_id, :integer
    add_column :mpd_expenses, :mpd_event_id, :integer
    # Create an event for every current project
    MpdUser.find(:all).each do |mpd_user|
      if mpd_user.get_application && mpd_user.get_application.project
        project = mpd_user.get_application.project
        event = mpd_user.mpd_events.create(:project_id => project.id, 
                                           :name => project.name,
                                           :start_date => project.start_date,
                                           :cost => project.student_cost)
        if event.id
          # Set this as the current event
          mpd_user.update_attribute(:current_event_id, event.id)
          
          # associate expenses with this event
          mpd_user.mpd_expenses.update_all("mpd_event_id = #{event.id}")
          action = MpdContactAction.find_by_event_id(project.id)
          action.update_attribute(:event_id, event.id) if action
        end
      end
    end
  end

  def self.down
    remove_column :mpd_expenses, :mpd_event_id
    rename_column :mpd_contact_actions, :event_id, :project_id
    remove_column :mpd_users, :current_event_id
    drop_table :mpd_events
  end
end
