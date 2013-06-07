class MpdExpense < ActiveRecord::Base
  belongs_to :mpd_user
  belongs_to :mpd_event
  belongs_to :mpd_expense_type
end
