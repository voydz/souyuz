# -*- encoding : utf-8 -*-
module Fastlane
  module Actions
    class SetAppVersionAction < Action
      def self.run(values)
        require 'souyuz'
        file_path = values[:plist_path] || values[:manifest_path]
        version, build = Helper::VersionHelper.set_version values[:version] values[:build]

        UI.important "Current Version is:"
        UI.message "  Version: #{version}"
        UI.message "  Build: #{build}"
      end

      def self.detect_manifest
        itr = 0
        query = 'AndroidManifest.xml'

        begin
           files = Dir.glob(query)
           query = "*/#{query}"
           itr += 1
        end until files.any? or itr > 1

        manifest_path = files.first # pick first file as solution
        UI.user_error! 'Not able to find AndroidManifest.xml automatically, try to specify it via `manifest_path` parameter.' unless manifest_path

        File.expand_path(manifest_path)
      end

      def self.description
        "Easily set app version with `set_app_version`"
      end

      def self.author
        "Felix Rudat"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :plist_path,
                                       env_name: "FL_APP_PLIST_PATH",
                                       description: "App plist file",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :manifest_path,
                                       env_name: "FL_APP_MANIFEST_PATH",
                                       description: "App manifest file",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "FL_APP_VERSION",
                                       description: "App version value",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :build,
                                       env_name: "FL_APP_BUILD",
                                       description: "App build number value",
                                       optional: true),
        ]
      end

      def self.is_supported?(platform)
        [:android, :ios, :mac].include? platform
      end
    end
  end
end
