ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'db_mappings'
class ActiveSupport::TestCase
  include ActionController::TestProcess
  fixtures :all

  # class << self
  #   def setup_fixture_accessors(table_names=nil)
  #     (table_names || fixture_table_names).each do |table_name|
  #       # raise ActiveRecord::Base.map_hash['tables'].inspect
  #       func = ActiveRecord::Base.map_hash['tables'].index(table_name) || table_name
  #       # raise 'hi' if table_name == 'accountadmin_viewer'
  #       table_name = table_name.to_s.tr('.','_')
  #       func = func.to_s.tr('.','_').pluralize
  #       define_method(func) do |fixture, *optionals|
  #         force_reload = optionals.shift
  #         @fixture_cache[table_name] ||= Hash.new
  #         @fixture_cache[table_name][fixture] = nil if force_reload
  #         if @loaded_fixtures[table_name][fixture.to_s]
  #           @fixture_cache[table_name][fixture] ||= @loaded_fixtures[table_name][fixture.to_s].find
  #         else
  #           raise StandardError, "No fixture with name '#{fixture}' found for table '#{table_name}'"
  #         end
  #       end
  #     end
  #   end
  # end
  # Add more helper methods to be used by all tests here...
end
