require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'shoulda/rails'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/has_draft'))

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'config', '/database.yml')))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.configurations = {'test' => config[ENV['DB'] || 'sqlite3']}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])

load(File.dirname(__FILE__) + "/schema.rb")

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$:.unshift(Test::Unit::TestCase.fixture_path)
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
end

require File.expand_path(File.join(File.dirname(__FILE__), '../init'))