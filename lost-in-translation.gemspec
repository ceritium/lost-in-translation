# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lost-in-translation}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["First Last"]
  s.date = %q{2009-06-28}
  s.email = %q{user@example.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/lost_in_translation", "lib/lost_in_translation/lost_in_translation.rb", "lib/lost_in_translation/version.rb", "lib/lost_in_translation.rb", "test/test_helper.rb", "test/unit", "test/unit/lost_in_translation_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://my-site.net}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{This gem does ...}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
