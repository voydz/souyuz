require 'souyuz/version'
require 'souyuz/manager'
require 'souyuz/runner'
require 'souyuz/options'
require 'souyuz/detect_values'
require 'souyuz/msbuild/project'
require 'souyuz/msbuild/solution'
require 'souyuz/msbuild/solution_parser'

require 'fastlane_core'

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