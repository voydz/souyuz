module Souyuz
  # Responsible for building the zipalign command
  class ZipalignCommandGenerator
    class << self
      def generate
        build_apk_path = Souyuz.cache[:build_apk_path]
        Souyuz.cache[:aligned_apk_path] = "#{build_apk_path}-aligned"

        parts = prefix
        parts << zipalign_apk
        parts += options
        parts << build_apk_path
        parts << Souyuz.cache[:aligned_apk_path]
        parts += pipe

        parts
      end

      def zipalign_apk
        zipalign = File.join(Souyuz.config[:buildtools_path], 'zipalign')

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
        [""]
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
