require 'souyuz/version'
require 'souyuz/platform'
require 'souyuz/manager'
require 'souyuz/generators/build_command_generator'
require 'souyuz/generators/zipalign_command_generator'
require 'souyuz/generators/apk_sign_command_generator'
require 'souyuz/generators/zip_dsym_command_generator'
require 'souyuz/runner'
require 'souyuz/options'
require 'souyuz/detect_values'
require 'souyuz/msbuild/project'
require 'souyuz/msbuild/solution'
require 'souyuz/msbuild/solution_parser'

require 'fastlane'

module Souyuz
  class << self
    attr_accessor :config

    attr_accessor :project

    attr_accessor :cache

    def config=(value)
      @config = value
      DetectValues.set_additional_default_values
      @cache = {}
    end
  end

  Helper = FastlaneCore::Helper # you gotta love Ruby: Helper.* should use the Helper class contained in FastlaneCore
  UI = FastlaneCore::UI
end
