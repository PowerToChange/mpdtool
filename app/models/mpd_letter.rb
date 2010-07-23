class MpdLetter < ActiveRecord::Base
  belongs_to :mpd_letter_template
  has_one :mpd_user
  has_many :mpd_letter_images
  
  validate :total_length
  
  @@max_letter_length = 3250
  
  def total_length
    sum = update_section.length + educate_section.length + needs_section.length + involve_section.length + acknowledge_section.length;
    errors.add_to_base("Letter can't be more than " + @@max_letter_length.to_s + " characters") if ( sum > @@max_letter_length)
  end
  
  def self.max_letter_length
    @@max_letter_length
  end
end