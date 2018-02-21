# -*- encoding : utf-8 -*-

require "commander"
require "fastlane"

HighLine.track_eof = false

module Souyuz
  class CommandsGenerator
    include Commander::Methods
    UI = FastlaneCore::UI

    FastlaneCore::CommanderGenerator.new.generate(Souyuz::Options.available_options)

    def self.start
      new.run
    end

    def convert_options(options)
      o = options.__hash__.dup
      o.delete(:verbose)
      o
    end

    def run
      program :version, Souyuz::VERSION
      program :description, Souyuz::DESCRIPTION
      program :help, "Author", "Felix Rudat <voydz@hotmail.com>"
      program :help_formatter, :compact

      global_option("--verbose") { $verbose = true }

      command :build do |c|
        c.syntax = "souyuz"
        c.description = "Just builds your app"
        c.action do |_args, options|
          config = FastlaneCore::Configuration.create(Souyuz::Options.available_options,
                                                      convert_options(options))
          Souyuz::Manager.new.work(config)
        end
      end

      default_command :build

      run!
    end
  end
end
