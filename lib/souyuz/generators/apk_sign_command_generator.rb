module Souyuz
  # Responsible for building the apksigner command
  class ApkSignCommandGenerator
    class << self
      def generate
        build_apk_path = Souyuz.cache[:build_apk_path]
        Souyuz.cache[:signed_apk_path] = "#{build_apk_path}-signed"

        parts = prefix
        parts << detect_apksigner_executable
        parts += options
        parts << Souyuz.cache[:aligned_apk_path]
        parts += pipe

        parts
      end

      def prefix
        [""]
      end

      def detect_apksigner_executable
        apksigner = File.join(Souyuz.config[:buildtools_path], 'apksigner')

        apksigner
      end

      def options
        options = []
        options << "sign"
        options << "--verbose" if $verbose
        options << "--ks \"#{Souyuz.config[:keystore_path]}\""
        options << "--ks-pass \"pass:#{Souyuz.config[:keystore_password]}\""
        options << "--ks-key-alias \"#{Souyuz.config[:keystore_alias]}\""
        options << "--out \"#{Souyuz.cache[:signed_apk_path]}\""

        options
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
