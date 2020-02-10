# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tax_calculator/version"

Gem::Specification.new do |spec|
  spec.name          = "tax_calculator"
  spec.version       = TaxCalculator::VERSION
  spec.authors       = ["Tai Tran"]
  spec.email         = ["transytai12a1@gmail.com"]

  spec.summary       = "Perform tax calculator"
  spec.description   = "Perform tax calculator"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
