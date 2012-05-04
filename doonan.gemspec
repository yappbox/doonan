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
  gem.add_dependency('hashie', '~> 1.0')
  gem.add_dependency('image_size', '~> 1.0')
  gem.add_dependency('multi_json', '~> 1.0')
  gem.add_dependency('fssm', '>= 0.2.7')
  gem.add_dependency('thor')

  gem.add_development_dependency('compass', '~> 0.11')
  gem.add_development_dependency('rspec')
end
