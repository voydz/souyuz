# souyuz plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-souyuz)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-souyuz`, add it to your project by running:

```bash
fastlane add_plugin souyuz
```

## Example

Check out the following lanes or the [example `Fastfile`](fastlane/Fastfile) to see how to use souyuz.

```ruby
platform :ios do
  lane :example do
    souyuz(
      platform: "ios",
      build_configuration: "Release",
      plist_path: "./iOS/Info.plist"
    )
  end
end
platform :android do
  lane :example do
    souyuz(
      platform: "android",
      build_configuration: "Release",
      keystore_path: "{PATH_TO_YOUR_KEYSTORE}",
      keystore_alias: "{ALIAS_OF_YOUR_KEYSTORE}",
      keystore_password: "{YOUR_SUPER_SECRET_KEYSTORE_PASSWORD}"
    )
  end
end
```

## About souyuz

A fastlane component to make Xamarin builds a breeze

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
