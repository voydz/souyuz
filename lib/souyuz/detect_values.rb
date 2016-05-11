require 'nokogiri'

module Souyuz
  # This class detects all kinds of default values
  class DetectValues
    # This is needed as these are more complex default values
    # Returns the finished config object
    def self.set_additional_default_values
      config = Souyuz.config

      # TODO detect_platform automatically for :platform config

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
      detect_assembly_name doc_csproj # we can only do that for android *after* we detected the android manitfest

      return config
    end

    # Helper Methods

    def self.detect_solution
      return if Souyuz.config[:solution_path]
      itr = 0
      query = '*.sln'

      begin
         files = Dir.glob(query)
         query = "../#{query}"
         itr += 1
      end until files.any? or itr > 3

      sln = files.first # pick first file as solution
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
      csproj = project.project_path
      UI.user_error! 'Not able to find project file automatically, try to specify it via `project_path` parameter.' unless csproj

      Souyuz.config[:project_name] = project.project_name
      Souyuz.config[:project_path] = abs_path csproj
    end

    def self.detect_output_path(doc_csproj)
      return if Souyuz.config[:output_path]

      configuration = Souyuz.config[:build_configuration]
      platform = Souyuz.config[:build_platform]

      doc_node = doc_csproj.xpath("/*[local-name()='Project']/*[local-name()='PropertyGroup'][translate(@*[local-name() = 'Condition'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz') = \" '$(configuration)|$(platform)' == '#{configuration.downcase}|#{platform.downcase}' \"]/*[local-name()='OutputPath']/text()")
      Souyuz.config[:output_path] = abs_project_path doc_node.text
    end

    def self.detect_manifest(doc_csproj)
      return if Souyuz.config[:manifest_path] or Souyuz.config[:platform] != Platform::ANDROID

      doc_node = doc_csproj.css('PropertyGroup > AndroidManifest')
      Souyuz.config[:manifest_path] = abs_project_path doc_node.text
    end

    def self.detect_assembly_name(doc_csproj)
      return if Souyuz.config[:assembly_name]

      if [ Platform::IOS, Platform::MAC ].include? Souyuz.config[:platform]
        Souyuz.config[:assembly_name] = doc_csproj.css('PropertyGroup > AssemblyName').text
      elsif Souyuz.config[:platform] == Platform::ANDROID
        doc = get_parser_handle Souyuz.config[:manifest_path] # explicitly for this call, no cache needed
        Souyuz.config[:assembly_name] = doc.xpath('string(//manifest/@package)')
      end
    end

    private

    def self.get_parser_handle(filename)
      f = File::open(filename)
      doc = Nokogiri::XML(f)   
      f.close

      return doc
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
  end 
end