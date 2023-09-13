# Souyuz

A fastlane component to make Xamarin builds a breeze. Souyuz is now avaialbe as an **Fastlane plugin** see [fastlane-plugin-souyuz](fastlane-plugin-souyuz) for details.

# inikityuk 12/09/2023
* Added support to build NET 7.0 Android / iOS projects (i.e. Xamarin Android / Xamarin iOS)

# inikityuk 16/08/2022
* iOS: added ability to create *.xcarchive on build

# inikityuk 27/05/2022
### Few major changes to "Souyuz" plugin
* Android: added ability to build AAB files (including signing)
* Android: added support to projects with multiple AndroidManifest files (handy if your build configuration using different ones)
* Android: added "key-password" signing property (handy if "store password" doesn't match with "key password")
* Android/iOS: added support for compile constants (handy if you using them as switches in projects)
* iOS: added ability to specify provisioning profile to sign with
* Updated readme with most common properties and basic usage

## How to use this fork
* Add to your "Pluginfile" inside "fastlane" folder one of this lines:
* gem 'fastlane-plugin-souyuz', github: "inikityuk/souyuz" # To pull gem from this fork (instead of official repo)
* gem 'fastlane-plugin-souyuz', path: "/{LOCAL_PATH_TO_PLUGIN}}/souyuz_fastlane_xamarin_plugin" # For local development (if you wish to apply your own modifications)

## Licensing

Souyuz is licensed under the MIT License. See [LICENSE](LICENSE) for the full license text.
