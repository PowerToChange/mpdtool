class AddPrintedNameToMpdLetters < ActiveRecord::Migration
  def self.up
    add_column(:mpd_letters, :printed_name, :string)
  end

  def self.down
    remove_column(:mpd_letters, :printed_name)
  end
end
