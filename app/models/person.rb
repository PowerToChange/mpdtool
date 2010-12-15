class Person < ActiveRecord::Base
  load_mappings
  include Common::Core::Person
  include Common::Core::Ca::Person

  def current_application
    user.current_application
  end
end
