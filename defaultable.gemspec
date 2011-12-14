# -*- encoding: utf-8 -*-
require File.expand_path('../lib/defaultable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robert Ross"]
  gem.email         = ["robert@maintainedauto.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "defaultable"
  gem.require_paths = ["lib"]
  gem.version       = Defaultable::VERSION

  gem.add_dependency("activesupport", "~> 3.1")

  gem.add_development_dependency("rspec", "~> 2.7")
  gem.add_development_dependency("pry")
end
