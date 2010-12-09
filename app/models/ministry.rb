class Ministry < ActiveRecord::Base
  load_mappings
  include Common::Core::Ministry
  include Common::Core::Ca::Ministry
end
