require 'acts_as_rateable'

ActiveRecord::Base.class_eval do
  include Acts::Rateable
end
