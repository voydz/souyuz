module Souyuz
  # Responsible for building the aabsigner command
  class AabSignCommandGenerator
    class << self
      def generate
        android_package_path = Souyuz.cache[:build_android_package_path]
        android_package_dir = File.dirname(android_package_path)
        android_package_filename_with_extension = "#{File.basename(android_package_path, ".*")}-signed#{File.extname(android_package_path)}"
        Souyuz.cache[:signed_android_package_path] = "#{File.join("#{android_package_dir}", "#{android_package_filename_with_extension}")}"

        parts = prefix
        parts << detect_jarsigner_executable
        parts += options
        parts += pipe

        parts
      end

      def detect_jarsigner_executable
        jarsigner = "/Library/Java/JavaVirtualMachines/microsoft-11.jdk/Contents/Home/bin/jarsigner"

        jarsigner
      end

      def prefix
        [""]
      end

      def options
        options = []
        options << "--verbose" if $verbose
        options << "-keystore \"#{Souyuz.config[:keystore_path]}\""
        options << "-storepass \"#{Souyuz.config[:keystore_password]}\""
        options << "-keypass \"#{Souyuz.config[:key_password]}\""
        options << "-digestalg \"SHA-256\""
        options << "-sigalg \"SHA256withRSA\""
        options << "-signedjar \"#{Souyuz.cache[:signed_android_package_path]}\" \"#{Souyuz.cache[:build_android_package_path]}\""
        options << "\"#{Souyuz.config[:keystore_alias]}\""

        options
      end

      def pipe
        pipe = []

        pipe
      end

      # VS does that
      # /Library/Java/JavaVirtualMachines/microsoft-11.jdk/Contents/Home/bin/jarsigner 
      # -keystore "debug.keystore" 
      # -storepass android 
      # -keypass android 
      # -digestalg SHA-256 
      # -sigalg SHA256withRSA 
      # -signedjar com.vald.dynamo.aab  
      # androiddebugkey 
    end
  end
end
