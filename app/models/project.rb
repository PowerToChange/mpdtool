class Project < ActiveRecord::Base
  load_mappings

  def name() title end
  def start_date() start end
end
