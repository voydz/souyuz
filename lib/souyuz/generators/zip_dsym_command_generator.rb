module Souyuz
  # Responsible for building the zip dsym command
  class ZipDsymCommandGenerator
    class << self
      def generate
        parts = prefix
        parts << detect_zip_executable
        parts += options
        parts += pipe

        parts
      end

      def prefix
        ["set -o pipefail &&"]
      end

      def detect_zip_executable
        # dunno if anyone wants a zip which is not available thorgh PATH
        # but if this case exists, we provide the opportunity to do so
        zip = ENV['SOUYUZ_ZIP_PATH'] || 'zip'

        zip
      end

      def options
        build_dsym_path = Souyuz.cache[:build_dsym_path]

        options = []
        options << "-r"
        options << "#{build_dsym_path}.zip"
        options << build_dsym_path

        options
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
