require 'fastlane'
require 'provision_util'

module Souyuz
  class Runner
    def run
      config = Souyuz.config

      if Souyuz.project.ios? or Souyuz.project.osx?

        configuration = "'#{config[:build_configuration]}|#{config[:build_platform]}'"

        # Set provisioning profile
        if config[:provision_profile_uuid]
          provision_profile_default_path = "#{Dir.home}/Library/MobileDevice/Provisioning\ Profiles/".freeze
          provision_profile_path = File.join provision_profile_default_path, "#{config[:provision_profile_uuid]}.mobileprovision"
          cert = ProvisionUtil::get_cert_from_provision(provision_profile_path)
          subject = Hash[cert.subject.to_a.map {|arr|  [arr[0], arr[1]]}]
          # config[:provision_profile_uuid] -> CodesignProvision
          name = subject['CN'] # CodesignKey

          file = File.new(Souyuz.config[:project_path])
          doc = Nokogiri::XML(file.read)
          file.close

          [
            ['CodesignProvision', config[:provision_profile_uuid]],
            ['CodesignKey', name]
          ].each do |dict|
            doc.search('PropertyGroup').each do |group|
              next unless !group['Condition'].nil? && group['Condition'].include?(configuration)
              property = group.search(dict[0])
              if property.size > 0
                property[0].content = dict[1]
              end
            end
          end


          xml = doc.to_xml
          UI.command_output(xml) if $verbose
          File.write(Souyuz.config[:project_path], xml)
        end
        
        # Add "ArchiveOnBuild"
        if config[:archive_app] == true
          file = File.new(Souyuz.config[:project_path])
          doc = Nokogiri::XML(file.read)
          file.close

          doc.search('PropertyGroup').each do |group|
            next unless !group['Condition'].nil? && group['Condition'].include?(configuration)
            archiveNode = Nokogiri::XML::Node.new "ArchiveOnBuild", doc
            archiveNode.content = config[:archive_app]
            group.add_child(archiveNode)
          end


          xml = doc.to_xml
          UI.command_output(xml) if $verbose
          File.write(Souyuz.config[:project_path], xml)
        end

        build_app
        
        compress_and_move_dsym
        path = ipa_file

        path
      elsif Souyuz.project.android?
        build_app

        android_package_format = Souyuz.cache[:android_package_format]
        path = android_package_file android_package_format

        if android_package_format.casecmp('apk').zero?
          if config[:keystore_path] && config[:keystore_alias] && config[:keystore_password]
            apksign_and_zipalign
          end
        elsif android_package_format.casecmp('aab').zero?
          if config[:keystore_path] && config[:keystore_alias] && config[:keystore_password]
            sign_aab_file
          end
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

    def android_package_file(file_format)
      build_path = Souyuz.project.options[:output_path]
      assembly_name = Souyuz.project.options[:assembly_name]

      build_android_package_path = File.join("#{build_path}", "#{assembly_name}.#{file_format}")
      Souyuz.cache[:build_android_package_path] = build_android_package_path

      build_android_package_path
    end

    def apksign_and_zipalign
      UI.success "Start signing APK process..."

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
        Souyuz.cache[:signed_android_package_path],
        Souyuz.cache[:build_android_package_path],
        :remove_destination => true)

      UI.success "Successfully signed apk #{Souyuz.cache[:build_android_package_path]}"
    end

    def sign_aab_file
      UI.success "Start signing AAB process..."

      command = AabSignCommandGenerator.generate
      FastlaneCore::CommandExecutor.execute(command: command,
                                            print_all: false,
                                            print_command: !Souyuz.config[:silent])
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
