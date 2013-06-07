class AutoDonation < ActiveRecord::Base
  load_mappings
  include Common::Core::Ca::AutoDonation
end
