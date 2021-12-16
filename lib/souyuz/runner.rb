require 'fastlane'

module Souyuz
  class Runner
    def run
      config = Souyuz.config

      build_app

      if Souyuz.project.ios? or Souyuz.project.osx?
        compress_and_move_dsym
        path = ipa_file

        path
      elsif Souyuz.project.android?
        path = apk_file
        if config[:keystore_path] && config[:keystore_alias]
          apksign_and_zipalign
        end

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

      build_apk_path = "#{build_path}/#{assembly_name}.apk"
      Souyuz.cache[:build_apk_path] = build_apk_path

      build_apk_path
    end

    def apksign_and_zipalign
      UI.success "Start signing process..."

      command = ZipalignCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !Souyuz.config[:silent])

      command = ApkSignCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: false,
                                            print_command: !Souyuz.config[:silent])

      # move signed apk back to build apk path
      FileUtils.cp_r(
        Souyuz.cache[:signed_apk_path],
        Souyuz.cache[:build_apk_path],
        :remove_destination => true)

      UI.success "Successfully signed apk #{Souyuz.cache[:build_apk_path]}"
    end

    #
    # ios build stuff to follow..
    #

    def package_path
      build_path = Souyuz.project.options[:output_path]
      assembly_name = Souyuz.project.options[:assembly_name]

      # in the upcomming switch we determin the output path of iOS ipa files
      # those change in the Xamarin.iOS Cycle 9 release
      # see https://developer.xamarin.com/releases/ios/xamarin.ios_10/xamarin.ios_10.4/
      if File.exist? "#{build_path}/#{assembly_name}.ipa"
        # after Xamarin.iOS Cycle 9
        package_path = build_path
      else
        # before Xamarin.iOS Cycle 9
        package_path = Dir.glob("#{build_path}/#{assembly_name} *").sort.last
      end

      package_path
    end

    def ipa_file
      assembly_name = Souyuz.project.options[:assembly_name]

      "#{package_path}/#{assembly_name}.ipa"
    end

    def compress_and_move_dsym
      build_path = Souyuz.project.options[:output_path]
      assembly_name = Souyuz.project.options[:assembly_name]

      build_dsym_path = "#{build_path}/#{assembly_name}.app.dSYM"
      unless File.exist? build_dsym_path
        UI.success "Did not found dSYM at #{build_dsym_path}, skipping..."
        return
      end

      Souyuz.cache[:build_dsym_path] = build_dsym_path

      command = ZipDsymCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: true,
                                            print_command: !Souyuz.config[:silent])

      # move dsym aside ipa
      dsym_path = "#{dsym_path}.zip"
      if File.exist? dsym_path
        FileUtils.mv(dsym_path, "#{package_path}/#{File.basename dsym_path}")
      end
    end
  end
end
