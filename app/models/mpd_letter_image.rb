class MpdLetterImage < ActiveRecord::Base
  belongs_to :mpd_letter
  file_column :image, :magick => {:versions => {:thumb  => {:crop => '1:1', :size => "50x50!"},
                                                :print => {:geometry => "400>"}}
  	                	          }
  validates_file_format_of :image, :in => ["image/jpeg", "image/png"]
  
  def image_name
    str = self.image.split("/")
    str[str.size - 1]
  end
end
