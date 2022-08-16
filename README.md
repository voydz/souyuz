# Souyuz

A fastlane component to make Xamarin builds a breeze. Souyuz is now avaialbe as an **Fastlane plugin** see [fastlane-plugin-souyuz](fastlane-plugin-souyuz) for details.

*NOTE: While souyuz should continue working with your existing configuration just fine, consider using the Fastlane plugin.*

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

## Using MSBuild

Since Version 0.7.0 souyuz is using `msbuild` by default, because according to Xamarin `xbuild` is deprecated and will be removed soon.

This change should not affect you under normal circumstances. Anyway, if you experience any issues there is a new config option `compiler_bin`, where you can easily pass `xbuild` in again.

Usage example:

```ruby
souyuz(
  compiler_bin: 'xbuild' # if xbuild is in your $PATH env variable
)
```

## ToDos

* clean up code (!!!)
* replace path concat with `File.join()`

## Licensing

Souyuz is licensed under the MIT License. See [LICENSE](LICENSE) for the full license text.
