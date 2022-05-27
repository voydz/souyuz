require "fastlane"

module Souyuz
  class Options

    PROVISION_FILES_DEFAULT_LOCATION = "#{Dir.home}/Library/MobileDevice/Provisioning\ Profiles/".freeze
    BUILD_PLATFORMS = %w(iPhone iPhoneSimulator AnyCPU).freeze

    def self.available_options
      [
        FastlaneCore::ConfigItem.new(key: :silent,
                                     env_name: "SOUYUZ_SILENT",
                                     description: "Hide all information that's not necessary while building",
                                     default_value: false,
                                     is_string: false),
        FastlaneCore::ConfigItem.new(key: :compiler_bin,
                                     env_name: "SOUYUZ_COMPILER_BIN",
                                     description: "Path to the compiler binary",
                                     default_value: 'msbuild'),
        FastlaneCore::ConfigItem.new(key: :build_configuration,
                                     env_name: "SOUYUZ_BUILD_CONFIGURATION",
                                     description: "Build configuration value",
                                     default_value: 'Release'),
        FastlaneCore::ConfigItem.new(key: :build_platform,
                                     env_name: "SOUYUZ_BUILD_PLATFORM",
                                     description: "Build platform value",
                                     default_value: 'iPhone',
                                     is_string: true,
                                     verify_block: proc do |value|
                                      UI.user_error!("Unsupported build platform, use one of #{BUILD_PLATFORMS}") unless BUILD_PLATFORMS.include? value
                                     end),
        FastlaneCore::ConfigItem.new(key: :build_target,
                                     env_name: "SOUYUZ_BUILD_TARGET",
                                     description: "Build targets to build",
                                     default_value: ['Build'],
                                     type: Array),
        FastlaneCore::ConfigItem.new(key: :extra_build_options,
                                     env_name: "SOUYUZ_EXTRA_BUILD_OPTIONS",
                                     description: "Extra options to pass to `msbuild`. Example: `/p:MYOPTION=true`",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :output_path,
                                     env_name: "SOUYUZ_BUILD_OUTPUT_PATH",
                                     description: "Build output path",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :project_name,
                                     env_name: "SOUYUZ_BUILD_PROJECT_NAME",
                                     description: "Build project name",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :assembly_name,
                                     env_name: "SOUYUZ_BUILD_ASSEMBLY_NAME",
                                     description: "Build assembly name",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :platform,
                                     env_name: "SOUYUZ_PLATFORM",
                                     description: "Targeted device platform (i.e. android, ios, osx)",
                                     optional: false),
        FastlaneCore::ConfigItem.new(key: :solution_path,
                                     env_name: "SOUYUZ_SOLUTION_PATH",
                                     description: "Path to the build solution (sln) file",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :project_path,
                                     env_name: "SOUYUZ_PROJECT_PATH",
                                     description: "Path to the build project (csproj) file",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :manifest_path,
                                     env_name: "SOUYUZ_ANDROID_MANIFEST_PATH",
                                     description: "Path to the android manifest (xml) file",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :buildtools_path,
                                     env_name: "SOUYUZ_ANDROID_BUILDTOOLS_PATH",
                                     description: "Path to the android build tools",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :plist_path,
                                     env_name: "SOUYUZ_IOS_PLIST_PATH",
                                     description: "Path to the iOS plist file",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :keystore_path,
                                     env_name: "SOUYUZ_ANDROID_KEYSTORE_PATH",
                                     description: "Path to the keystore",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :keystore_alias,
                                     env_name: "SOUYUZ_ANDROID_KEYSTORE_ALIAS",
                                     description: "Alias of the keystore",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :keystore_password,
                                     env_name: "SOUYUZ_ANDROID_KEYSTORE_PASSWORD",
                                     description: "Password of the keystore",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :key_password,
                                     env_name: "SOUYUZ_ANDROID_KEY_PASSWORD",
                                     description: "Password of the key",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :keystore_tsa,
                                     default_value: 'http://timestamp.digicert.com',
                                     env_name: "SOUYUZ_ANDROID_KEYSTORE_TSA",
                                     description: "TSA for apksigner",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :provision_profile_uuid,
                                     env_name: "SOUYUZ_IOS_PP_UUID",
                                     description: "UUID of provision profile in default dir",
                                     is_string: true,
                                     optional: true,
                                     verify_block: proc do |uuid|
                                      file = File.join PROVISION_FILES_DEFAULT_LOCATION, "#{uuid}.mobileprovision"
                                      UI.user_error!('Empty input') if file.nil?
                                      UI.user_error!("#{file} does not exist") unless File.exist? file
                                      UI.user_error!("#{file} is not a file") unless File.file? file
                                      # check if newer PP exist
                                     end)
      ]
    end
  end
end
