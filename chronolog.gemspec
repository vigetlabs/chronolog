# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chronolog/version'

Gem::Specification.new do |spec|
  spec.name          = "chronolog"
  spec.version       = Chronolog::VERSION
  spec.authors       = ["Ryan Stenberg, David Eisinger"]
  spec.email         = ["ryan.stenberg@viget.com", "david.eisinger@viget.com"]

  spec.summary       = 'Change Tracking for ActiveAdmin'
  spec.description   = 'Chronolog adds diff-powered change tracking to Rails apps using ActiveAdmin + Devise.'
  spec.homepage      = 'https://github.com/vigetlabs/chronolog'
  spec.license       = 'BSD'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails",       "~> 4.2"
  spec.add_dependency "activeadmin", "1.0.0pre2"
  spec.add_dependency "devise",      "~> 3.5"

  spec.add_development_dependency "bundler",            "~> 1.11"
  spec.add_development_dependency "rake",               "~> 10.0"
  spec.add_development_dependency "rspec",              "~> 3.0"
  spec.add_development_dependency "shoulda-matchers"
  spec.add_development_dependency "factory_girl_rails", "~> 4.6"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "simplecov"
end
