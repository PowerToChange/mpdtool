class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :mpd_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :mpd_sessions, :session_id
    add_index :mpd_sessions, :updated_at
  end

  def self.down
    drop_table :mpd_sessions
  end
end
