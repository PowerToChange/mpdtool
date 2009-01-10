class MpdUser < ActiveRecord::Base
  belongs_to :mpd_letter
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"#, :include => {:person => :current_application}

  has_and_belongs_to_many :mpd_roles

  has_many :mpd_contacts,
           :order => "full_name ASC"
  has_many :mpd_expenses  
  has_many :mpd_events

  after_create :create_expenses_for_user
  
  validates_presence_of :user_id
  validates_uniqueness_of :user_id
  
  def mpd_contacts_to_call(event_id)
    MpdContact.find(:all, :conditions => ["mpd_user_id = ? AND event_id = ? and call_made = 0", self.id, event_id], :order => "full_name ASC", :joins => :mpd_contact_actions)
  end
  
  def mpd_contacts_to_thank(event_id)
    @contacts_to_thanks ||= MpdContact.find(:all, :conditions => ["mpd_user_id = ? AND event_id = ? and thankyou_sent = 0", self.id, event_id], :joins => :mpd_contact_actions)
  end
  
  def create_expenses_for_user
    if self.mpd_expenses.empty?
      for expense_type in MpdExpenseType.find(:all)
        expense = MpdExpense.create(:mpd_user_id => self.id,
                                    :mpd_expense_type_id => expense_type.id)
        expense.save
        self.mpd_expenses << expense
      end

      self.save
    # else 
    #   raise self.mpd_expenses.inspect
    end
  end
  
  def support_total(event_id = nil)
    unless @total_expenses
      event = get_event(event_id)
      @total_expenses = event.mpd_expenses.sum(:amount).to_i
      @total_expenses += event_cost(event_id).to_i
    end
    @total_expenses
  end
  
  def event_start_date(event_id)
    get_event(event_id).start_date.to_time if get_event(event_id)
  end
  
  def event_cost(event_id = nil)
    unless @event_cost
      event = get_event(event_id)
      if event && event.cost
        @event_cost = event.cost
      end
      @event_cost ||= 0
    end
    return @event_cost
  end
  
  def app_accepted_date
    get_application.accepted_at if get_application 
  end
  
  # private
  def get_event(event_id)
    unless @event
      if event_id
        @event = mpd_events.find(event_id)
      end
      # If no id was passed in, or no event was found with that id, get the first event
      @event ||= mpd_events.first
    end
    return @event
  end
  
  def get_application
    @app ||= self.user.person.current_application
  end
  
  # def self.has_access(user)
  #   mpd_user = self.find_by_user_id(user.id)
  #   unless mpd_user
  #     # See if there's a project this user is on, and create an mpd user for them.
  #     app = user.person.current_application
  #     if app
  #       mpd_user = self.create(:user_id => user.id, :last_login => Time.now)
  #     end
  #   end
  #   mpd_user
  # end
end
