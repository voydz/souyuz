module Souyuz
  # Responsible for building the zipalign command
  class ZipalignCommandGenerator
    class << self
      def generate
        android_package_path = Souyuz.cache[:build_android_package_path]
        android_package_dir = File.dirname(android_package_path)
        android_package_filename_with_extension = "#{File.basename(android_package_path, ".*")}-aligned#{File.extname(android_package_path)}"
        Souyuz.cache[:aligned_apk_path] = "#{File.join("#{android_package_dir}", "#{android_package_filename_with_extension}")}"

        parts = prefix
        parts << zipalign_apk
        parts += options
        parts << android_package_path
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
