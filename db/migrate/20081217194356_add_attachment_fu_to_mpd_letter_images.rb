class AddAttachmentFuToMpdLetterImages < ActiveRecord::Migration
  def self.up
    add_column :mpd_letter_images, :parent_id, :integer
    add_column :mpd_letter_images, :content_type, :string
    add_column :mpd_letter_images, :filename, :string
    add_column :mpd_letter_images, :thumbnail, :string
    add_column :mpd_letter_images, :size, :integer
    add_column :mpd_letter_images, :width, :integer
    add_column :mpd_letter_images, :height, :integer
  end

  def self.down
    remove_column :mpd_letter_images, :parent_id
    remove_column :mpd_letter_images, :content_type
    remove_column :mpd_letter_images, :filename
    remove_column :mpd_letter_images, :thumbnail
    remove_column :mpd_letter_images, :size
    remove_column :mpd_letter_images, :width
    remove_column :mpd_letter_images, :height
   end
end
