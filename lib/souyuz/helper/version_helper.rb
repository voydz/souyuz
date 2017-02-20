# -*- encoding : utf-8 -*-
module Souyuz
  module Helper
    class VersionHelper
      class << self
        def self.set_version(version, build, file_path = nil)
          if Souyuz.project.ios? or Souyuz.project.mac?
            set_plist_version version build file_path
          elsif Souyuz.project.android?
            set_manifest_version version build file_path
          end
        end

        def self.set_plist_version(version, build, plist_path = nil)
          plist_path ||= Souyuz.config[:plist_path]
          version ||= other_action.get_info_plist_value(path: plist_path, key: 'CFBundleShortVersionString')
          build ||= other_action.get_info_plist_value(path: plist_path, key: 'CFBundleVersion')

          other_action.set_info_plist_value(
            path: plist_path, 
            key: 'CFBundleShortVersionString', 
            value: version
          )

          other_action.set_info_plist_value(
            path: plist_path 
            key: 'CFBundleVersion', 
            value: build
          )

          [version, build]
        end

        def self.set_manifest_version(version, build, manifest_path = nil)
          manifest_path ||= Souyuz.config[:manifest_path]

          # parse the doc
          f = File.open(manifest_path)
          doc = Nokogiri::XML(f)
          f.close

          attrs = doc.xpath('//manifest')[0]

          version ||= attrs['android:versionName']
          build ||= attrs['android:versionCode']

          if version or build
            attrs['android:versionName'] = version if version
            attrs['android:versionCode'] = build if build

            # save the doc
            File.open(manifest_path, 'w') do |f| 
                f.print(doc.to_xml) 
            end
          end

          [version, build]
        end
      end
    end
  end
end
