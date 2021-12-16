# Souyuz

A fastlane component to make Xamarin builds a breeze. Souyuz is now avaialbe as an **Fastlane plugin** see [fastlane-plugin-souyuz](fastlane-plugin-souyuz) for details.

*NOTE: While souyuz should continue working with your existing configuration just fine, consider using the Fastlane plugin.*

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
