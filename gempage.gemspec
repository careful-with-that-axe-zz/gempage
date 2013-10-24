# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gempage/version'

Gem::Specification.new do |s|
  s.name          = "gempage"
  s.version       = Gempage::VERSION
  s.authors       = ["Jane S. Sebastian"]
  s.email         = ["jane@betatetra.com"]
  s.description   = %Q{A reference page for gems installed within a Rails application.}
  s.summary       = %Q{Work in progress yo.}
  s.homepage      = "https://github.com/careful-with-that-axe"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sprockets'
  s.add_development_dependency 'uglifier'
  s.add_development_dependency 'sass'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
