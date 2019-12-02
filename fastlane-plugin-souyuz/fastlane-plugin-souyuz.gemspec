lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fastlane/plugin/souyuz/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-souyuz'
  spec.version       = Fastlane::Souyuz::VERSION
  spec.author        = 'Felix Rudat'
  spec.email         = 'voydz@hotmail.com'

  spec.summary       = 'A fastlane component to make Xamarin builds a breeze'
  spec.homepage      = 'https://github.com/voydz/souyuz'
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'souyuz', Fastlane::Souyuz::VERSION

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fastlane', '>= 1.103.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
end
