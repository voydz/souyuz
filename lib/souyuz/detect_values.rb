require 'nokogiri'

module Souyuz
  # This class detects all kinds of default values
  class DetectValues
    # This is needed as these are more complex default values
    # Returns the finished config object
    def self.set_additional_default_values
      config = Souyuz.config

      # Detect the project
      Souyuz.project = Msbuild::Project.new(config)
      detect_solution
      detect_csproj

      # TODO handle real configuration and platform (as specified by csproj)

      detect_platform # we can only do that *after* we have the csproj

      detect_manifest # doc (csproj)
      detect_assembly_name # doc (csproj ios, manifest android)
      detect_output_path # doc (csproj), config, platform

      config[:output_name] ||= Souyuz.project.app_name

      return config
    end

    # Helper Methods

    def self.detect_solution
      return if Souyuz.config[:solution_path]
      itr = 0
      path = '*.sln'
      solution = nil

      while itr < 3 do
         files = Dir.glob(path)
         if (files.any?)
           solution = files.first
           break
         end
         path = "../#{path}"
         itr += 1
      end

      Souyuz.config[:solution_path] = solution
    end

    def self.detect_csproj
      return if Souyuz.config[:project_path]

      path = Souyuz.config[:solution_path]
      projects = Msbuild::SolutionParser.parse(path)
        .select { |p| p.is_platform? platform }

      csproj = projects.first[:project_file_path]
      Souyuz.config[:project_path] = failsafe_path csproj
    end

    def self.detect_platform
      return if Souyuz.config[:platform]
      Souyuz.config[:platform] = Souyuz.project.platform
    end

    def self.detect_assembly_name
      return if Souyuz.config[:assembly_name]
      platform = Souyuz.config[:platform]
      
      if [ :ios, :mac ].include? platform
        Souyuz.config[:assembly_name] = doc.css('PropertyGroup > AssemblyName').text
      elsif platform == :android
        Souyuz.config[:assembly_name] = doc.xpath('string(//manifest/@package)')
      end
    end

    def self.detect_output_path
      if [ :ios, :mac ].include? Souyuz.config[:platform]
        
      elsif Souyuz.config[:platform] == :android
        platform = 'AnyCPU'.downcase
      end

      doc_node = doc.xpath("/*[local-name()='Project']/*[local-name()='PropertyGroup'][translate(@*[local-name() = 'Condition'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz') = \" '$(configuration)|$(platform)' == '#{configuration.downcase}|#{platform.downcase}' \"]/*[local-name()='OutputPath']/text()")
      failsafe_path doc_node.text
    end

   def self.detect_manifest
     return if Souyuz.config[:manifest_path] or Souyuz.config[:platform] != :android
     Souyuz.config[:manifest_path] = failsafe_path doc.css('PropertyGroup > AndroidManifest').text
    end

    private

    def self.get_parser_handle(file)
      File::open(filename) do |f|
        doc = Nokogiri::XML(f)   
      end
      return doc
    end

    def self.failsafe_path(path)
      path = path.gsub('\\', '/') # dir separator fix
      path = File.expand_path(path) # absolute dir
      path
    end
  end 
end