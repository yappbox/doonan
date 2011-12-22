# -*- encoding: utf-8 -*-
require File.expand_path('../lib/doonan/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Luke Melia"]
  gem.email         = ["luke@lukemelia.com"]
  gem.description   = %q{Doonan helps you generate CSS presentation code based on json and file inputs.}
  gem.summary       = %q{Doonan helps you generate CSS presentation code based on json and file inputs.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "doonan"
  gem.require_paths = ["lib"]
  gem.version       = Doonan::VERSION
  gem.add_dependency('tilt', '>= 1.3.3')
  gem.add_dependency('sass', '>= 3.1')
  gem.add_dependency('compass', '>= 0.11.5')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('css_parser')
  gem.add_development_dependency('ruby-debug19')
end
