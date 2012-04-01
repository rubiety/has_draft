# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "has_draft/version"

Gem::Specification.new do |s|
  s.name        = "has_draft"
  s.version     = HasDraft::VERSION
  s.author      = "Ben Hughes"
  s.email       = "ben@railsgarden.com"
  s.homepage    = "http://github.com/rubiety/has_draft"
  s.summary     = "Attached draft model to your ActiveRecord models."
  s.description = "Allows for your ActiveRecord models to have drafts which are stored in a separate duplicate table."
  
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  
  s.add_dependency("activesupport", [">= 3.0.0"])
  s.add_dependency("activerecord", [">= 3.0.0"])
  s.add_development_dependency("rspec", ["~> 2.0"])
  s.add_development_dependency("factory_girl", ["~> 1.3.1"])
  s.add_development_dependency("faker", ["~> 0.9.1"])
  s.add_development_dependency("sqlite3-ruby", ["~> 1.3.1"])
  s.add_development_dependency "rake"
end
