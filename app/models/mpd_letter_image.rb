class MpdLetterImage < ActiveRecord::Base
  has_attachment :storage => :file_system,
                 :thumbnails => { :thumb => '50x50!', :print => '400>' }

  belongs_to :mpd_letter
  
  def image_name
    str = self.image.split("/")
    str[str.size - 1]
  end
end
