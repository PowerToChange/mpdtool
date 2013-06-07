class MpdEvent < ActiveRecord::Base
  has_many :mpd_expenses, :dependent => :destroy
  has_many :mpd_contact_actions, :class_name => "MpdContactAction", :foreign_key => "event_id", :dependent => :destroy
  belongs_to :mpd_user
  belongs_to :mpd_letter
  belongs_to :project
  validates_presence_of :cost, :on => :update, :message => "can't be blank"
  validates_presence_of :start_date, :name
  
  after_create :create_contact_actions
  
  def create_contact_actions
    mpd_user.mpd_contacts.each do |contact|
      MpdContactAction.create(:contact_id => contact.id, :event_id => self.id) unless contact.action(self.id)
    end
  end

  def cost
    profile.try(:cached_costing_total) || self[:cost]
  end

  def profile
    mpd_user.user.profiles.find_by_project_id self.project_id
  end
end
