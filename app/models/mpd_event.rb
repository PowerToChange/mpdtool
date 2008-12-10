class MpdEvent < ActiveRecord::Base
  has_many :mpd_expenses
  validates_presence_of :cost, :on => :update, :message => "can't be blank"
  validates_presence_of :start_date, :name
end
