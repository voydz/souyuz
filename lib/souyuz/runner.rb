# -*- encoding : utf-8 -*-
module Souyuz
  class Runner
    def run
      build_app

      if Souyuz.project.ios? or Souyuz.project.mac?
        compress_and_move_dsym
        path = ipa_file

        path
      elsif Souyuz.project.android?
        path = apk_file
        # jarsign_and_zipalign TODO implement later

        path
      end
    end

    def build_app
      command = BuildCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                          print_all: true,
                                      print_command: !Souyuz.config[:silent])
    end

    #
    # android build stuff to follow..
    #

    def apk_file
      build_path = Souyuz.project.options[:output_path]
      assembly_name = Souyuz.project.options[:assembly_name]

      "#{build_path}/#{assembly_name}.apk"
    end

    def jarsign_and_zipalign
      command = JavaSignCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                          print_all: true,
                                      print_command: !Souyuz.config[:silent])

      command = AndroidZipalignCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                          print_all: true,
                                      print_command: !Souyuz.config[:silent])
    end

    #
    # ios build stuff to follow..
    #

    def package_path
      build_path = Souyuz.project.options[:output_path]
      assembly_name = Souyuz.project.options[:assembly_name]

      package_path = Dir.glob("#{build_path}/#{assembly_name} *").sort.last
    end

    def ipa_file
      assembly_name = Souyuz.project.options[:assembly_name]

      "#{package_path}/#{assembly_name}.ipa"
    end

    def compress_and_move_dsym
      require 'fileutils'
      build_path = Souyuz.project.options[:output_path]
      assembly_name = Souyuz.project.options[:assembly_name]
      dsym_path = "#{build_path}/#{assembly_name}.app.dSYM"

      # compress dsym using zip
      if File.exists? dsym_path
        zip = ENV['SOUYUZ_ZIP_PATH'] || 'zip'
        command = "#{zip} -r #{dsym_path}.zip #{dsym_path}"
        Helper.backticks(command, print: !Souyuz.config[:silent])
        dsym_path = "#{dsym_path}.zip"
      end

      # move dsym aside ipa
      if File.exists? dsym_path
        FileUtils.mv(dsym_path, "#{package_path}/#{File.basename dsym_path}")
      end
    end
  end
end
