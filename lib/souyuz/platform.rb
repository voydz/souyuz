module Souyuz
  module Platform
    IOS = 'ios'
    OSX = 'osx'
    ANDROID = 'android'

    def self.from_lane_context(context)
      current_platform = context[:PLATFORM_NAME].to_s

      # map in the future, if necessary

      current_platform
    end
  end
end
