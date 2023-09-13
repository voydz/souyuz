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
        parts << detect_zipalign_executable
        parts += options
        parts << android_package_path
        parts << Souyuz.cache[:aligned_apk_path]
        parts += pipe

        parts
      end

      def detect_zipalign_executable
        buildtools = Souyuz.config[:buildtools_root_path]
        version = Dir.entries(buildtools).sort.last
  
        zipalign = File.join(buildtools, version, 'zipalign')

        zipalign
      end

      def options
        options = []
        options << "-v" if $verbose
        options << "-p"
        options << "-f" # override file
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

      # VS does that
      # /Users/inikityuk/Library/Developer/Xamarin/android-sdk-macosx/build-tools/32.0.0/zipalign
      # -p 
      # 4 
      # "com.vald.dynamo.staging.apk" 
      # "com.vald.dynamo.staging-Signed.apk" 
    end
  end
end
