# -*- encoding : utf-8 -*-
module Fastlane
  module Actions
    module SharedValues
      # for calabash
      APP_BUNDLE_PATH = :APP_BUNDLE_PATH
      APP_OUTPUT_PATH = :APP_OUTPUT_PATH
    end

    class SouyuzAction < Action
      def self.run(values)
        require 'souyuz'

        if Souyuz.project.ios? or Souyuz.project.mac?
          values[:platform] = Souyuz::Platform::IOS

          absolute_ipa_path = File.expand_path(Souyuz::Manager.new.work(values))
          absolute_app_path = File.join(values[:output_path], "#{values[:assembly_name]}.app")
          absolute_dsym_path = absolute_ipa_path.gsub(".ipa", ".app.dSYM.zip")
          
          Actions.lane_context[SharedValues::APP_OUTPUT_PATH] = absolute_app_path
          Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] = absolute_ipa_path
          Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] = absolute_dsym_path if File.exist?(absolute_dsym_path)
          ENV[SharedValues::APP_OUTPUT_PATH.to_s] = absolute_app_path
          ENV[SharedValues::APP_BUNDLE_PATH.to_s] = absolute_app_path # for calabash
          ENV[SharedValues::IPA_OUTPUT_PATH.to_s] = absolute_ipa_path # for deliver
          ENV[SharedValues::DSYM_OUTPUT_PATH.to_s] = absolute_dsym_path if File.exist?(absolute_dsym_path)

          absolute_ipa_path
        elsif Souyuz.project.android?
          values[:platform] = Souyuz::Platform::ANDROID

          absolute_apk_path = File.expand_path(Souyuz::Manager.new.work(values))

          Actions.lane_context[SharedValues::GRADLE_BUILD_TYPE] = values[:build_configuration]
          Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH] = absolute_apk_path

          absolute_apk_path
        end
      end

      def self.description
        "Easily build and sign your app using `souyuz_ios`"
      end

      def self.return_value
        "The absolute path to the generated ipa file"
      end

      def self.author
        "Felix Rudat"
      end

      def self.available_options
        require 'souyuz'
        Souyuz::Options.available_options
      end

      def self.is_supported?(platform)
        [:android, :ios, :mac].include? platform
      end
    end
  end
end
