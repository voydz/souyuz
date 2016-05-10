module Souyuz
  class Runner
      def run
      unless Souyuz.config[:skip_build_archive]
        clear_old_files
        build_app
      end
      verify_archive

      FileUtils.mkdir_p(Souyuz.config[:output_directory])

      if Souyuz.project.ios? || Souyuz.project.tvos?
        fix_generic_archive
        package_app
        fix_package
        compress_and_move_dsym
        path = move_ipa
        move_manifest
        move_app_thinning
        move_app_thinning_size_report
        move_apps_folder

        path
      elsif Souyuz.project.mac?
        compress_and_move_dsym
        copy_mac_app
      end
    end
  end
end