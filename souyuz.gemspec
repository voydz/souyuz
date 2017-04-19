# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "souyuz/version"

Gem::Specification.new do |s|
  s.name        = 'souyuz'
  s.version     = Souyuz::VERSION
  s.summary     = Souyuz::DESCRIPTION
  s.description = Souyuz::DESCRIPTION
  s.authors     = ["Felix Rudat"]
  s.email       = 'voydz@hotmail.com'
  s.homepage    = 'http://rubygems.org/gems/souyuz'
  s.license     = 'MIT'

  s.required_ruby_version = ">= 2.0.0"

  s.files = Dir["lib/**/*"] + %w(bin/souyuz README.md LICENSE)

  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri', '~> 1.7'
  s.add_dependency 'highline', '~> 1.7'

  # Development only
  s.add_dependency 'rspec'
  s.add_dependency 'rubocop'
  
  s.add_development_dependency 'magic_encoding'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end
