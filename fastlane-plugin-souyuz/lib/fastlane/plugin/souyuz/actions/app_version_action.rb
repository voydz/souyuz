module Fastlane
  module Actions
    class AppVersionAction < Action
      def self.run(values)
        require 'souyuz'
        values[:platform] = ::Souyuz::Platform.from_lane_context(Actions.lane_context)
        ::Souyuz.config = values

        if ::Souyuz.project.ios? or ::Souyuz.project.osx?
          version, build = set_plist_version values[:version], values[:build], values[:plist_path]
        elsif ::Souyuz.project.android?
          version, build = set_manifest_version values[:version], values[:build], values[:manifest_path]
        end

        UI.important "Current Version is:"
        UI.message "  Version: #{version}"
        UI.message "  Build: #{build}"
      end

      def self.set_plist_version(version, build, plist_path = nil)
        plist_path ||= ::Souyuz.config[:plist_path]
        version ||= other_action.get_info_plist_value(path: plist_path, key: 'CFBundleShortVersionString')
        build ||= other_action.get_info_plist_value(path: plist_path, key: 'CFBundleVersion')

        other_action.set_info_plist_value(
          path: plist_path,
          key: 'CFBundleShortVersionString',
          value: version
        )

        other_action.set_info_plist_value(
          path: plist_path,
          key: 'CFBundleVersion',
          value: build
        )

        [version, build]
      end

      def self.set_manifest_version(version, build, manifest_path = nil)
        manifest_path ||= ::Souyuz.config[:manifest_path]

        # parse the doc
        f1 = File.open(manifest_path)
        doc = Nokogiri::XML(f1)
        f1.close

        attrs = doc.xpath('//manifest')[0]

        version ||= attrs['android:versionName']
        build ||= attrs['android:versionCode']

        if version or build
          attrs['android:versionName'] = version if version
          attrs['android:versionCode'] = build if build

          # save the doc
          File.open(manifest_path, 'w') do |f2|
            f2.print(doc.to_xml)
          end
        end

        [version, build]
      end

      def self.description
        "Easily set or print app version with `app_version`"
      end

      def self.author
        "Felix Rudat"
      end

      def self.available_options
        require 'souyuz'
        ::Souyuz::Options.available_options.concat(
          [
            FastlaneCore::ConfigItem.new(key: :version,
                                         env_name: "FL_APP_VERSION",
                                         description: "App version value",
                                         optional: true),
            FastlaneCore::ConfigItem.new(key: :build,
                                         env_name: "FL_APP_BUILD",
                                         description: "App build number value",
                                         optional: true)
          ]
        )
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
