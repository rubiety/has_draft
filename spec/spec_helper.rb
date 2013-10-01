require "rubygems"
require "rspec"
require "factory_girl"
require "faker"
require "active_record"
require "active_support"

# Establish DB Connection
config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'db', 'database.yml')))
ActiveRecord::Base.configurations = {'test' => config[ENV['DB'] || 'sqlite3']}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])

# Load Test Schema into the Database
load(File.dirname(__FILE__) + "/db/schema.rb")

require File.dirname(__FILE__) + '/../init'

# Example has_draft Model:
class Article < ActiveRecord::Base
  has_draft
end

# Empty class to test ability of Draft class to extend other classes
class Post < ActiveRecord::Base

end

# Model for testing ability to have the draft extend a different class
class BlogPost < Post
  has_draft extends: Post, belongs_to: :post
end

# Load Factories:
Dir[File.join(File.dirname(__FILE__), "factories/**/*.rb")].each {|f| require f}
