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
      build_target: ['Clean','Build'], # OPTIONAL - default to 'Build'
      build_platform: "ios-arm64", # OPTIONAL -> One of "ios-arm64 iossimulator-x64 AnyCPU" -> default to iOS:"ios-arm64", Android:"AnyCPU"
      build_configuration: "Release", # OPTIONAL -> default to "Release"
      plist_path: "./iOS/Info.plist",
      provision_profile_uuid: "{PROVISIONING_PROFILE_TO_SIGN_WITH}", # OPTIONAL -> default to Visual Studio configuration
      archive_app: true # Create *.xcarchive file, -> default to "false"
    )
  end
end
platform :android do
  lane :example do
    souyuz(
      platform: "android",
      build_configuration: "Release",
      build_target: ['Clean','Build'], # OPTIONAL - default to 'Build'
      build_platform: "AnyCPU", # OPTIONAL -> One of "ios-arm64 iossimulator-x64 AnyCPU" -> default to iOS:"ios-arm64", Android:"AnyCPU"
      keystore_path: "{PATH_TO_YOUR_KEYSTORE}", # OPTIONAL - if not provided Xamarin default keystore will be used
      keystore_alias: "{ALIAS_OF_YOUR_KEYSTORE}", # OPTIONAL - if not provided Xamarin default keystore will be used
      keystore_password: "{YOUR_SUPER_SECRET_KEYSTORE_PASSWORD}", # OPTIONAL - if not provided Xamarin default keystore will be used
      key_password: "{YOUR_SUPER_SECRET_KEY_PASSWORD}" # OPTIONAL - if not provided Xamarin default keystore will be used
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
