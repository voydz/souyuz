# -*- encoding : utf-8 -*-
require "fastlane_core"

module Souyuz
  class Manager
    def work(options)
      Souyuz.config = options

      FastlaneCore::PrintTable.print_values(config: Souyuz.config,
                                            hide_keys: [],
                                            title: "Summary for souyuz #{Souyuz::VERSION}")

      return Runner.new.run
    end
  end
end
