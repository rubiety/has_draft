# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_draft}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Hughes"]
  s.date = %q{2009-01-16}
  s.description = %q{Allows for your ActiveRecord models to have drafts which are stored in a separate duplicate table.}
  s.email = %q{ben@railsgarden.com}
  s.extra_rdoc_files = ["CHANGELOG", "lib/has_draft.rb", "README.rdoc", "tasks/has_draft_tasks.rake"]
  s.files = ["CHANGELOG", "has_draft.gemspec", "init.rb", "install.rb", "lib/has_draft.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README.rdoc", "tasks/has_draft_tasks.rake", "test/config/database.yml", "test/fixtures/article_drafts.yml", "test/fixtures/articles.yml", "test/has_draft_test.rb", "test/models/article.rb", "test/schema.rb", "test/test_helper.rb", "uninstall.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/railsgarden/has_draft}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Has_draft", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{has_draft}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Allows for your ActiveRecord models to have drafts which are stored in a separate duplicate table.}
  s.test_files = ["test/has_draft_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
