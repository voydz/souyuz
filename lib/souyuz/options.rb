require "fastlane_core"
require "credentials_manager"

module Souyuz
  class Options
    def self.available_options
      [
        FastlaneCore::ConfigItem.new(key: :silent,
                                     short_option: "-a",
                                     env_name: "SOUYUZ_SILENT",
                                     description: "Hide all information that's not necessary while building",
                                     default_value: false,
                                     is_string: false),
        FastlaneCore::ConfigItem.new(key: :build_configuration,
                                     env_name: "SOUYUZ_BUILD_CONFIGURATION",
                                     description: "Xbuild configuration value",
                                     default_value: 'Release'),
        FastlaneCore::ConfigItem.new(key: :build_platform,
                                     env_name: "SOUYUZ_BUILD_PLATFORM",
                                     description: "Xbuild platform value",
                                     default_value: 'iPhone'),
        FastlaneCore::ConfigItem.new(key: :build_target,
                                     env_name: "SOUYUZ_BUILD_TARGET",
                                     description: "Xbuild targets to build",
                                     default_value: 'Build'),
        FastlaneCore::ConfigItem.new(key: :output_path,
                                     env_name: "SOUYUZ_BUILD_OUTPUT_PATH",
                                     description: "Xbuild output path",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :project_name,
                                     env_name: "SOUYUZ_BUILD_PROJECT_NAME",
                                     description: "Xbuild project name",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :assembly_name,
                                     env_name: "SOUYUZ_BUILD_ASSEMBLY_NAME",
                                     description: "Xbuild assembly name",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :platform,
                                     env_name: "SOUYUZ_PLATFORM",
                                     description: "Targeted device platform (i.e. android, ios, mac)",
                                     optional: false),
        FastlaneCore::ConfigItem.new(key: :solution_path,
                                     env_name: "SOUYUZ_SOLUTION_PATH",
                                     description: "Path to the xbuild solution (sln) file",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :project_path,
                                     env_name: "SOUYUZ_PROJECT_PATH",
                                     description: "Path to the xbuild project (csproj) file",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :manifest_path,
                                     env_name: "SOUYUZ_ANDROID_MANIFEST_PATH",
                                     description: "Path to the android manifest (xml) file",
                                     optional: true),
      ]
    end
  end
end