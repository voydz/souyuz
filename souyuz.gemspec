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
  s.homepage    = 'https://github.com/voydz/souyuz'
  s.license     = 'MIT'

  s.required_ruby_version = ">= 2.2.0"

  s.files = Dir["lib/**/*"] + %w(bin/souyuz README.md LICENSE)

  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'fastlane', '>= 2.29.0'
  s.add_dependency 'highline', '~> 1.7'
  s.add_dependency 'nokogiri', '~> 1.7'

  # Development only
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '0.49.1'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end
