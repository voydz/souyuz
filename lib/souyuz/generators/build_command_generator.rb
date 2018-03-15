module Souyuz
  # Responsible for building the fully working build command
  class BuildCommandGenerator
    class << self
      def generate
        parts = prefix
        parts << compiler_bin
        parts += options
        parts += targets
        parts += project
        parts += pipe

        parts
      end

      def prefix
        ["set -o pipefail &&"]
      end

      def compiler_bin
        Souyuz.config[:compiler_bin]
      end

      def options
        config = Souyuz.config

        options = []
        options << "/p:Configuration=#{config[:build_configuration]}" if config[:build_configuration]
        options << config[:extra_build_options] if config[:extra_build_options]
        options << "/p:Platform=#{config[:build_platform]}" if Souyuz.project.ios? and config[:build_platform]
        options << "/p:BuildIpa=true" if Souyuz.project.ios?
        if config[:solution_path]
          solution_dir = File.dirname(config[:solution_path])
          options << "/p:SolutionDir=#{solution_dir}/"
        end

        options
      end

      def build_targets
        Souyuz.config[:build_target].map! { |t| "/t:#{t}" }
      end

      def targets
        targets = []
        targets += build_targets
        targets << "/t:SignAndroidPackage" if Souyuz.project.android?

        targets
      end

      def project
        path = []

        path << Souyuz.config[:project_path] if Souyuz.project.android?
        path << Souyuz.config[:solution_path] if Souyuz.project.ios? or Souyuz.project.osx?

        path
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
