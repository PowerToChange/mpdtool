class MpdLetter < ActiveRecord::Base
  belongs_to :mpd_letter_template
  has_one :mpd_user
  has_many :mpd_letter_images
  
  validates_length_of :update_section, :educate_section, :needs_section, :involve_section, :acknowledge_section, :maximum => 1000, :allow_nil => true,
                      :message => "is too long."
end