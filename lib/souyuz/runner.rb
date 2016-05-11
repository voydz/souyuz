module Souyuz
  class Runner
    def run
      if Souyuz.project.ios? || Souyuz.project.mac?
        build_ipa
        compress_and_move_dsym

        path = ipa_file

        path
      elsif Souyuz.project.android?
        build_apk

        path = apk_file

        path
      end
    end

    #
    # android build stuff to follow..
    #

    def build_apk
      csproj = Souyuz.project.options[:project_path]
      configuration = Souyuz.project.options[:build_configuration]
      target = Souyuz.project.options[:build_target]

      # TODO extract to command class
      xbuild = ENV['MSBUILD_PATH'] || 'xbuild'
      command = "#{xbuild}"\
        " /p:Configuration=#{configuration}"\
        " /t:#{target}"\
        " #{csproj}"

      FastlaneCore::CommandExecutor.execute(command: command,
                                          print_all: true,
                                      print_command: !Souyuz.config[:silent])
    end

    def apk_file
      build_path = Souyuz.project.options[:output_path]
      assembly_name = Souyuz.project.options[:assembly_name]

      "#{build_path}/#{assembly_name}.apk"
    end

    #
    # ios build stuff to follow..
    #

    def build_ipa
      solution = Souyuz.project.options[:solution_path]
      configuration = Souyuz.project.options[:build_configuration]
      platform = Souyuz.project.options[:build_platform]
      target = Souyuz.project.options[:build_target]

      # TODO extract to command class
      xbuild = ENV['SOUYUZ_MSBUILD_PATH'] || 'xbuild'
      command = "#{xbuild}"\
          " /p:Configuration=#{configuration}"\
          " /p:Platform=#{platform}"\
          " /p:BuildIpa=true"\
          " /t:#{target}"\
          " #{solution}"

      FastlaneCore::CommandExecutor.execute(command: command,
                                          print_all: true,
                                      print_command: !Souyuz.config[:silent])
    end

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