ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'db_mappings'
class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false
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
