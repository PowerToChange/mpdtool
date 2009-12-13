require 'test/unit'

#Unit tests.
require File.dirname(__FILE__) + '/test_unit.rb'

#Functional tests.
Dir[File.dirname(__FILE__) + '/functional/*.rb'].each do |file|
  require file
end
