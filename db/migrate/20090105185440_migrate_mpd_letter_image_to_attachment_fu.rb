require 'mime/types'
require File.join(RAILS_ROOT, 'app', 'models', 'mpd_letter_image')

class MpdLetterImage < ActiveRecord::Base
  def set_from_file(source_file)
    source_file_extension = File.extname(source_file.path).reverse.chomp('.').reverse
    source_file_name = File.basename(source_file.path)
    self.content_type = self.class.mime_type_from_extension(source_file_extension)
    self.filename = source_file_name
    self.temp_data = source_file.read
    true
  end

  def self.mime_type_from_extension(extension)
    MIME::Types.type_for(extension).first.simplified
  end
end

class MigrateMpdLetterImageToAttachmentFu < ActiveRecord::Migration
  def self.up
    change_column :mpd_letter_images, :mpd_letter_id, :integer, :null => true
    for mpd_letter_image in MpdLetterImage.find(:all)
      #image_filename = select_value "SELECT image FROM profiles WHERE id = #{profile.id}" 

      image_filename = mpd_letter_image[:image]
      unless image_filename.blank?
        image_path = File.join(RAILS_ROOT, 'public', 'files', 'mpd_letter_image', 'image', '0000', sprintf('%04d', mpd_letter_image.id), image_filename)
        if File.exists?(image_path)
          image_file = File.open(image_path, 'r')

          #photo = ProfilePhoto.new(:profile_id => profile.id)
          mpd_letter_image.set_from_file(image_file)
          mpd_letter_image.save!
        end
      end
    end
  end

  def self.down
  end
end
