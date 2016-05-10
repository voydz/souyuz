require "fastlane_core"
require "credentials_manager"

module Souyuz
  class Options
    def self.available_options
      [
        FastlaneCore::ConfigItem.new(key: :configuration,
                                     env_name: "SOUYUZ_BUILD_CONFIGURATION",
                                     description: "Xbuild configuration value",
                                     default_value: 'Release'),
        FastlaneCore::ConfigItem.new(key: :platform,
                                     env_name: "SOUYUZ_BUILD_PLATFORM",
                                     description: "Xbuild platform value",
                                     default_value: 'iPhone'),
        FastlaneCore::ConfigItem.new(key: :target,
                                     env_name: "SOUYUZ_BUILD_TARGET",
                                     description: "Xbuild targets to build",
                                     default_value: 'Build'),
        FastlaneCore::ConfigItem.new(key: :solution,
                                     env_name: "SOUYUZ_XBUILD_SOLUTION",
                                     description: "Path to the xbuild solution file",
                                     optional: true),
      ]
    end
  end
end