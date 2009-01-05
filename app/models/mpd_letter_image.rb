class MpdLetterImage < ActiveRecord::Base
  has_attachment :storage => :file_system,
                 :thumbnails => { :thumb => '50x50!', :print => '400>' }

  belongs_to :mpd_letter
  file_column :image, :magick => {:versions => {:thumb  => {:crop => '1:1', :size => "50x50!"},
                                                :print => {:geometry => "400>"}}
  	                	          }
  validates_file_format_of :image, :in => ["png", "jpg", 'JPG', 'PNG']
  
  def image_name
    str = self.image.split("/")
    str[str.size - 1]
  end
end
