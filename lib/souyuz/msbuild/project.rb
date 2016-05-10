module Souyuz
  module Msbuild
    class Project
      attr_accessor :options

      def initialize(options)
        @options = options
      end

      def name
        @options[:name]
      end

      def project_file_path
        @options[:project_file_path]
      end

      def platform
        return :ios if self.is_platform? :ios
        return :mac if self.is_platform? :mac
        return :android if self.is_platform? :android
      end

      def is_platform?(platform)
        case platform
        when :ios
          self.name.downcase.include? 'ios'
        when :mac
          self.name.downcase.include? 'mac'
        when :android
          self.name.downcase.include? 'droid'
        end
        return false
      end
    end
  end
end
