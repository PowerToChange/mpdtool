class User < ActiveRecord::Base
  load_mappings
  include Common::Core::User
  include Common::Pat::User
  include Common::Core::Ca::User

  def current_application
    profiles.find(:last, :conditions => "type = 'Acceptance' OR type = 'StaffProfile'", :order => 'project_id desc')
  end

  def self.find_by_id(id)
    find_by_viewer_id(id)
  end
end
