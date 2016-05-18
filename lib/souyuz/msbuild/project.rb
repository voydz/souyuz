# -*- encoding : utf-8 -*-
module Souyuz
  module Msbuild
    class Project
      attr_accessor :options

      def initialize(options)
        @options = options
      end

      def project_name
        @options[:project_name]
      end

      def project_path
        @options[:project_path]
      end

      def ios?
        is_platform? Souyuz::Platform::IOS
      end

      def mac?
        is_platform? Souyuz::Platform::MAC
      end

      def android?
        is_platform? Souyuz::Platform::ANDROID
      end

      def is_platform?(platform)
        return case platform
          when Souyuz::Platform::IOS 
            then self.project_name.downcase.include? 'ios'
          when Souyuz::Platform::MAC 
            then self.project_name.downcase.include? 'mac'
          when Souyuz::Platform::ANDROID 
            then self.project_name.downcase.include? 'droid'
          else false
        end
      end
    end
  end
end
