module Souyuz
  # Responsible for building the zipalign command
  class AndroidZipalignCommandGenerator
    class << self
      def generate
        parts = prefix
        parts << zipalign_apk
        parts += options
        parts << Souyuz.cache[:signed_apk_path]
        parts << Souyuz.cache[:build_apk_path]
        parts += pipe

        parts
      end

      def detect_build_tools
        # determine latest buildtool version
        buildtools = File.join(ENV['ANDROID_HOME'], 'build-tools')
        version = Dir.entries(buildtools).sort.last

        UI.success "Using Buildtools Version: #{version}..."

        [buildtools, version]
      end

      def zipalign_apk
        buildtools, version = detect_build_tools
        zipalign = ENV['ANDROID_HOME'] ? File.join(buildtools, version, 'zipalign') : 'zipalign'

        zipalign
      end

      def options
        options = []
        options << "-v" if $verbose
        options << "-f"
        options << "4"

        options
      end

      def prefix
        ["set -o pipefail &&"]
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
