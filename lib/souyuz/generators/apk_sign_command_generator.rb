module Souyuz
  # Responsible for building the apksigner command
  class ApkSignCommandGenerator
    class << self
      def generate
        android_package_path = Souyuz.cache[:build_android_package_path]
        android_package_dir = File.dirname(android_package_path)
        android_package_filename_with_extension = "#{File.basename(android_package_path, ".*")}-signed#{File.extname(android_package_path)}"
        Souyuz.cache[:signed_android_package_path] = "#{File.join("#{android_package_dir}", "#{android_package_filename_with_extension}")}"

        parts = prefix
        parts << detect_java_executable
        parts << detect_apksigner_executable
        parts += options
        parts << Souyuz.cache[:aligned_apk_path]
        parts += pipe

        parts
      end

      def prefix
        [""]
      end

      def detect_java_executable
        java = "/Library/Java/JavaVirtualMachines/microsoft-11.jdk/Contents/Home/bin/java -jar"
        
        UI.success "*** IGOR-TESTING *** -> java path + parameter: #{java}"

        java
      end

      def detect_apksigner_executable
        microsoft_buildtools = "/usr/local/share/dotnet/packs/Microsoft.Android.Sdk.Darwin"
        version = Dir.entries(microsoft_buildtools).sort.last
        
        apksigner = "#{File.join(microsoft_buildtools, version, 'tools', 'apksigner.jar')}"

        UI.success "*** IGOR-TESTING *** -> microsoft_buildtools path for apksigner: #{microsoft_buildtools} -> Version: #{version}"

        apksigner
      end

      def options
        options = []
        options << "sign"
        options << "--verbose" if $verbose
        options << "--ks \"#{Souyuz.config[:keystore_path]}\""
        options << "--ks-pass \"pass:#{Souyuz.config[:keystore_password]}\""
        options << "--ks-key-alias \"#{Souyuz.config[:keystore_alias]}\""
        options << "--key-pass \"pass:#{Souyuz.config[:key_password]}\""
        options << "--min-sdk-version #{Souyuz.cache[:android_min_sdk_version]}"
        options << "--max-sdk-version #{Souyuz.cache[:android_target_sdk_version]}"
        options << "--out \"#{Souyuz.cache[:signed_android_package_path]}\""

        options
      end

      # VS does that
      # /Library/Java/JavaVirtualMachines/microsoft-11.jdk/Contents/Home/bin/java -jar 
      # /usr/local/share/dotnet/packs/Microsoft.Android.Sdk.Darwin/33.0.68/tools/apksigner.jar sign 
      # --ks "debug.keystore" 
      # --ks-pass pass:android 
      # --ks-key-alias androiddebugkey 
      # --key-pass pass:android 
      # --min-sdk-version 23 
      # --max-sdk-version 33  
      # com.vald.dynamo.staging-Signed.apk 

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
