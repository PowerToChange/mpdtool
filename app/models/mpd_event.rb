class MpdEvent < ActiveRecord::Base
  has_many :mpd_expenses
  belongs_to :mpd_user
  validates_presence_of :cost, :on => :update, :message => "can't be blank"
  validates_presence_of :start_date, :name
  
  after_create :create_contact_actions
  
  def create_contact_actions
    mpd_user.mpd_contacts.each do |contact|
      MpdContactAction.create(:contact_id => contact.id, :event_id => self.id) unless contact.action(self.id)
    end
  end
end
