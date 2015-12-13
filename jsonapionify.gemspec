# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapionify/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonapionify"
  spec.version       = JSONAPIonify::VERSION
  spec.authors       = ["Jason Waldrip"]
  spec.email         = ["jason@waldrip.net"]

  spec.summary       = %q{Ruby object structure conforming to the JSON API spec.}
  spec.homepage      = "https://github.com/brandfolder/jsonapionify"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(vendor|spec)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "rack"
  spec.add_dependency "redcarpet"
  spec.add_dependency "oj"
  spec.add_dependency "rack-test"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rocco"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "navigable_hash"
  spec.add_development_dependency "code-statistics"
  spec.add_development_dependency "codeclimate-test-reporter"
end
