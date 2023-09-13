require 'nokogiri'

module Souyuz
  # This class detects all kinds of default values
  class DetectValues
    # This is needed as these are more complex default values
    # Returns the finished config object
    def self.set_additional_default_values
      config = Souyuz.config

      # TODO: detect_platform automatically for :platform config

      # set correct implicit build platform for android
      if config[:platform] == Platform::ANDROID
        config[:build_platform] = 'AnyCPU'
      end

      # Detect the project
      Souyuz.project = Msbuild::Project.new(config)
      detect_solution
      detect_project # we can only do that *after* we detected the solution

      doc_csproj = get_parser_handle config[:project_path]

      detect_output_path doc_csproj
      detect_manifest doc_csproj
      detect_info_plist
      detect_assembly_name doc_csproj # we can only do that for android *after* we detected the android manitfest
      detect_min_max_sdk doc_csproj # we can only do that for android *after* we detected the android manitfest
      detect_compile_constants doc_csproj # all platforms
      detect_android_package_format doc_csproj

      return config
    end

    # Helper Methods

    def self.detect_solution
      return if Souyuz.config[:solution_path]

      sln = find_file('*.sln', 3) # search for solution
      UI.user_error! 'Not able to find solution file automatically, try to specify it via `solution_path` parameter.' unless sln

      Souyuz.config[:solution_path] = abs_path sln
    end

    def self.detect_project
      return if Souyuz.config[:project_path]

      path = Souyuz.config[:solution_path]
      projects = Msbuild::SolutionParser.parse(path)
                                        .get_platform Souyuz.config[:platform]

      UI.user_error! "Not able to find any project in solution, that matches the platform `#{Souyuz.config[:platform]}`." unless projects.any?

      project = projects.first
      csproj = fix_path_relative project.project_path # get path relative to project root
      UI.user_error! 'Not able to find project file automatically, try to specify it via `project_path` parameter.' unless csproj

      Souyuz.config[:project_name] = project.project_name
      Souyuz.config[:project_path] = abs_path csproj
    end

    def self.detect_output_path(doc_csproj)
      return if Souyuz.config[:output_path]

      configuration = Souyuz.config[:build_configuration]

      target_framework_node = doc_csproj.css('PropertyGroup > TargetFramework')
      target_framework = target_framework_node.text

      output_path = File.join("bin", "#{configuration}", "#{target_framework}")
      Souyuz.config[:output_path] = abs_project_path output_path
    end

    def self.detect_manifest(doc_csproj)
      return if Souyuz.config[:manifest_path] or Souyuz.config[:platform] != Platform::ANDROID

      configuration = Souyuz.config[:build_configuration]
      platform = "AnyCPU"

      doc_node = doc_csproj.xpath("/*[local-name()='Project']/*[local-name()='PropertyGroup'][translate(@*[local-name() = 'Condition'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz') = \" '$(configuration)|$(platform)' == '#{configuration.downcase}|#{platform.downcase}' \"]/*[local-name()='AndroidManifest']/text()")

      # For AAB builds: "<AndroidManifest> tag might be missed, so falling back to first available value"
      doc_node = doc_csproj.css('PropertyGroup > AndroidManifest').first if doc_node.empty?

      Souyuz.config[:manifest_path] = abs_project_path doc_node.text
    end

    def self.detect_info_plist
      return if Souyuz.config[:plist_path] or Souyuz.config[:platform] != Platform::IOS

      plist_path = find_file('Info.plist', 1) # search for plist
      UI.user_error! 'Not able to find Info.plist automatically, try to specify it via `plist_path` parameter.' unless plist_path

      Souyuz.config[:plist_path] = abs_project_path plist_path
    end

    def self.detect_assembly_name(doc_csproj)
      return if Souyuz.config[:assembly_name]

      if [Platform::IOS, Platform::OSX].include? Souyuz.config[:platform]
        Souyuz.config[:assembly_name] = doc_csproj.css('PropertyGroup > AssemblyName').text
      elsif Souyuz.config[:platform] == Platform::ANDROID
        doc = get_parser_handle Souyuz.config[:manifest_path] # explicitly for this call, no cache needed
        Souyuz.config[:assembly_name] = doc.xpath('string(//manifest/@package)')
      end
    end

    def self.detect_min_max_sdk(doc_csproj)
      if Souyuz.config[:platform] == Platform::ANDROID
        doc = get_parser_handle Souyuz.config[:manifest_path] # explicitly for this call, no cache needed
        Souyuz.cache[:android_min_sdk_version] = doc.xpath('string(//manifest/uses-sdk/@android:minSdkVersion)')
        Souyuz.cache[:android_target_sdk_version] = doc.xpath('string(//manifest/uses-sdk/@android:targetSdkVersion)')
      end
    end

    private_class_method

    def self.find_file(query, depth)
      itr = 0
      files = []

      loop do
        files = Dir.glob(query)
        query = "../#{query}"
        itr += 1
        break if files.any? or itr > depth
      end

      return files.first # pick first file
    end

    def self.get_parser_handle(filename)
      f = File.open(filename)
      doc = Nokogiri::XML(f)
      f.close

      return doc
    end

    def self.fix_path_relative(path)
      root = File.dirname Souyuz.config[:solution_path] # failsafe to __FILE__ and __DIR__
      path = "#{root}/#{path}"
      path
    end

    def self.abs_project_path(path)
      path = path.gsub('\\', '/') # dir separator fix
      platform_path = Souyuz.config[:project_path]
      path = "#{File.dirname platform_path}/#{path}"
      path
    end

    def self.abs_path(path)
      path = path.gsub('\\', '/') # dir separator fix
      path = File.expand_path(path) # absolute dir
      path
    end

    def self.detect_compile_constants(doc_csproj)
      configuration = Souyuz.config[:build_configuration]
      platform = "AnyCPU"

      compile_constants_node = doc_csproj.xpath("/*[local-name()='Project']/*[local-name()='PropertyGroup'][translate(@*[local-name() = 'Condition'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz') = \" '$(configuration)|$(platform)' == '#{configuration.downcase}|#{platform.downcase}' \"]/*[local-name()='DefineConstants']/text()")
      Souyuz.cache[:compile_constants] = compile_constants_node.text.gsub(";", " ")
      compile_constants_node.text
    end

    def self.detect_android_package_format(doc_csproj)
      configuration = Souyuz.config[:build_configuration]
      platform = "AnyCPU"

      android_package_format_node = doc_csproj.xpath("/*[local-name()='Project']/*[local-name()='PropertyGroup'][translate(@*[local-name() = 'Condition'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz') = \" '$(configuration)|$(platform)' == '#{configuration.downcase}|#{platform.downcase}' \"]/*[local-name()='AndroidPackageFormat']/text()")
      Souyuz.cache[:android_package_format] = android_package_format_node.text
      android_package_format_node.text
    end
  end
end
