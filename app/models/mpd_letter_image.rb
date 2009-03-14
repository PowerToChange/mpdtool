class MpdLetterImage < ActiveRecord::Base
  has_attachment :storage => :s3,
                 :thumbnails => { :thumb => '50x50!', :print => '400>' },
                 :content_type => [
                                    'image/jpeg',
                                    'image/pjpeg',
                                    'image/jpg',
                                    'image/gif',
                                    'image/jpg',
                                    'image/jp_',
                                    'application/jpg',
                                    'application/x-jpg',
                                    'image/vnd.swiftview-jpeg',
                                    'image/gi_',
                                    'image/x-citrix-pjpeg'
                                  ]

  belongs_to :mpd_letter
  
  def image_name
    str = self.image.split("/")
    str[str.size - 1]
  end
end
