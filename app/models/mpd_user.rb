class MpdUser < ActiveRecord::Base
  belongs_to :mpd_letter
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"#, :include => {:person => :current_application}

  has_and_belongs_to_many :mpd_roles

  has_many :mpd_contacts,
           :order => "full_name ASC"
  has_many :mpd_expenses  

  after_create :create_expenses_for_user
  
  validates_presence_of :user_id
  validates_uniqueness_of :user_id
  
  def mpd_contacts_to_call
    MpdContact.find(:all, :conditions => ["mpd_user_id = ? and call_made = 0", self.id], :order => "full_name ASC")
  end
  
  def mpd_contacts_to_thank
    @contacts_to_thanks ||= MpdContact.find(:all, :conditions => ["mpd_user_id = ? and thankyou_sent = 0", self.id])
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
  
  def support_total
    @total_expenses ||= MpdExpense.sum(:amount, :conditions => "mpd_user_id = #{self.id}").to_i
    @project_cost.to_i + @total_expenses
  end
  
  def project_start_date
    get_project.start_date.to_time if get_project
  end
  
  def project_cost
    unless @project_cost
      if get_project && get_project.student_cost
        @project_cost = get_project.student_cost
      else
        @project_cost = 0
      end
    end
    return @project_cost
  end
  
  def app_accepted_date
    get_application.accepted_at if get_project 
  end
  
  # private
  def get_project
    @project ||= get_application.project if get_application
    return @project
  end
  
  def get_application
      @app ||= self.user.person.current_application
  end
  
  def self.has_access(user)
    mpd_user = self.find_by_user_id(user.id)
    unless mpd_user
      # See if there's a project this user is on, and create an mpd user for them.
      app = user.person.current_application
      if app
        mpd_user = self.create(:user_id => user.id, :last_login => Time.now)
      end
    end
    mpd_user
  end
end
