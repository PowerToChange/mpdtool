class MpdLetter < ActiveRecord::Base
  belongs_to :mpd_letter_template
  belongs_to :mpd_user
  has_many :mpd_letter_images
  has_one :mpd_event
  
  validate :total_length
  
  validates_uniqueness_of(:name, :scope => :mpd_user_id, :allow_blank => false)
  
  @@max_letter_length = 3250
  
  def total_length
    sum = (update_section.blank? ? 0 : update_section.length) + 
          (educate_section.blank? ? 0 : educate_section.length) + 
          (needs_section.blank? ? 0 : needs_section.length) + 
          (involve_section.blank? ? 0 : involve_section.length) + 
          (acknowledge_section.blank? ? 0 : acknowledge_section.length);
    errors.add_to_base("Letter can't be more than " + @@max_letter_length.to_s + " characters") if ( sum > @@max_letter_length)
  end
  
  def self.max_letter_length
    @@max_letter_length
  end

  def create_any_blank_images!
    if mpd_letter_template
      (mpd_letter_template.number_of_images - mpd_letter_images.count).times do |i|
        mpd_letter_images.new.save(false)
      end
    end
  end
end
