class MpdLetterImage < ActiveRecord::Base
  has_attachment :storage => :file_system,
                 :size => 1..3.megabytes,
                 :thumbnails => { :thumb => '50x50!', :print => '400>' },
                 :content_type => [
                                    'image/jpeg',
                                    'image/pjpeg',
                                    'image/jpg',
                                    'image/gif',
                                    'image/png',
                                    'image/x-png',
                                    'image/jpg',
                                    'image/jp_',
                                    'image/gi_',
                                    'image/x-citrix-pjpeg'
                                  ]

  belongs_to :mpd_letter
  
  validates_as_attachment
  
  def check_valid? #Only check for validation if this record has actually been populated
    if !filename.blank?
      valid?
    else
      true
    end
  end
  
  def image_name
    str = self.image.split("/")
    str[str.size - 1]
  end
end
