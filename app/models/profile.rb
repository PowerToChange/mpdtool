class Profile < ActiveRecord::Base
  load_mappings
  include Common::Pat::Profile

  def project_cost() project[:cached_costing_total] end
end
