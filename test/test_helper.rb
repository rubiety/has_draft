require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_support/test_case'
require 'active_record/fixtures'
require 'shoulda/rails'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/has_draft'))

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'config', '/database.yml')))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.configurations = {'test' => config[ENV['DB'] || 'sqlite3']}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])

load(File.dirname(__FILE__) + "/schema.rb")

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.dirname(__FILE__) + "/fixtures/"
  #self.use_transactional_fixtures = true # can't figure out why this throws now. :(
  self.use_instantiated_fixtures = false
end

$:.unshift(ActiveSupport::TestCase.fixture_path)
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))

require File.expand_path(File.join(File.dirname(__FILE__), '../init'))
