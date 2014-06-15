# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'one_secret/version'

Gem::Specification.new do |spec|
  spec.name          = "one_secret"
  spec.version       = OneSecret::VERSION
  spec.authors       = ["Omer Lachish-Rauchwerger"]
  spec.email         = ["omer@rauchy.net"]
  spec.summary       = %q{Keep application secrets easily and securely as part of your Rails app.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
