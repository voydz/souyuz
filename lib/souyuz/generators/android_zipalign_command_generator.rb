module Souyuz
  # Responsible for building the zipalign command
  # TODO implement
  class AndroidZipalignCommandGenerator
    class << self
      def generate
       
        parts = prefix
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

        sh "\"#{zipalign}\" -f -v 4 #{signed_apk} #{aligned_apk}"
        Helper.backticks(command, print: !Souyuz.config[:silent])
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