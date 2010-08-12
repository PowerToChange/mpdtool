class MpdContact < ActiveRecord::Base
  acts_as_rateable
  
  belongs_to :mpd_user
  belongs_to :mpd_priority
  has_many :mpd_contact_actions
  
  validates_presence_of :full_name
  validates_presence_of :salutation, :on => :update, :message => "can't be blank"
  validates_format_of :phone, :with => /^(\(?[0-9]{3}[\)-\.]?\ ?)?[0-9]{3}[-\.]?[0-9]{4}$/,
                              :if => Proc.new { |c| !c.phone.blank? }
  validates_format_of :email_address, :with => /^[a-z0-9!$'*+\-_]+(\.[a-z0-9!$'*+\-_]+)*@([a-z0-9]+(-+[a-z0-9]+)*\.)+([a-z]{2}|aero|arpa|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|travel)$/,
                                      :if => Proc.new { |c| !c.email_address.blank? }
  validates_format_of :zip, :with => /^([0-9]{5}([\s-]{1}[0-9]{4})?)|([a-zA-Z]{1}[0-9]{1}[a-zA-Z]{1}(\-| |){1}[0-9]{1}[a-zA-Z]{1}[0-9]{1})$/,
                            :if => Proc.new { |c| !c.zip.blank? }  
  before_create :set_salutation
  
  after_create :create_contact_actions

  def display_address(lb = false)
    ret_val = ""
    if !self.address_1.nil? and !self.address_1.empty?
      ret_val += address_1
      if lb 
        ret_val += "<br/>"
      else 
        ret_val += ", "
      end 
      ret_val += city + ", " + state + " " + zip
    else 
      ret_val = nil
    end
    return ret_val
  end
  
  def send_letter!(event_id)
    action(event_id).update_attribute(:letter_sent, true)
  end
  
  def make_call!(event_id)
    action(event_id).update_attribute(:call_made, true)
  end
  
  def send_thankyou!(event_id)
    action(event_id).update_attribute(:thankyou_sent, true)
  end
  
  def selected!(event_id, context)
    @current_action = action(event_id)
    
    case context
      when "letter" then @current_action.update_attribute(:is_selected_letter, !@current_action.is_selected_letter?)
      when "call" then @current_action.update_attribute(:is_selected_call, !@current_action.is_selected_call?)
      when "thank you" then @current_action.update_attribute(:is_selected_thankyou, !@current_action.is_selected_thankyou?)
    else false
    end
  end
  
  def salutation
    self[:salutation] || self.full_name
  end
  
  def gift_amount(event_id)
    action(event_id).gift_amount || 0
  end
  
  def letter_sent(event_id)
    action(event_id).letter_sent?
  end
  
  def call_made(event_id)
    action(event_id).call_made?
  end
  
  def thankyou_sent(event_id)
    action(event_id).thankyou_sent?
  end
  
  def is_selected(event_id, context)
    case context
      when "letter" then action(event_id).is_selected_letter?
      when "call" then action(event_id).is_selected_call?
      when "thank you" then action(event_id).is_selected_thankyou?
    else false
    end
  end
  
  def action(event_id)
    raise 'need an event_id' unless event_id
    @actions ||= {}
    unless @actions[event_id]
      @actions[event_id] = mpd_contact_actions.find_by_event_id(event_id)
      @actions[event_id] ||= mpd_contact_actions.create(:event_id => event_id)
    end
    @actions[event_id]
  end

  protected
  
  def set_salutation
  # Check for more than one first name
    self.salutation =  
    if self.full_name[/\w+(\s+([&]|(and))\s+\w+)+/] #Catches any number of 'ands' ie. ("Bob and Sue & Bill and ... Johnson")
      self.full_name[/\w+(\s+([&]|(and))\s+\w+)+/]
    else
      self.full_name.chomp(" " + self.full_name.split(" ")[-1])
    end
  end
  
  def create_contact_actions
    mpd_user.mpd_events.each do |event|
      MpdContactAction.create(:contact_id => self.id, :event_id => event.id) unless self.action(event.id)
    end
  end  
end
