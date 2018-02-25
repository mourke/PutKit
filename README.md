# PutIOKit
Objective-C wrapper for Put.io API

![Travis](https://travis-ci.org/mourke/PutIOKit.svg?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#installation-with-carthage) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/PutIOKit.svg)](#installation-with-cocoapods) ![Swift 4.0.x](https://img.shields.io/badge/Swift-4.0.x-orange.svg) ![Platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg) [![License](https://img.shields.io/badge/license-MIT-414141.svg)](https://github.com/mourke/PutIOKit/blob/master/LICENSE)

## Installation with CocoaPods

Install cocoapods with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate PutIOKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'PutIOKit', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

## Installation with Carthage

Install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

#### Cartfile

To integrate PutIOKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "mourke/PutIOKit"  ~> 1.0
```

Run `carthage` to build the framework and drag the built `PutIOKit.framework` into your Xcode project.

## Usage

### Setting Your API Information

The API information must be set every time the application starts. If you do not do this, an exception will be raised on any attempt to make calls to the wrapper. The best place to do this is  inside the `application:didFinishLaunchingWithOptions:` function in your **AppDelegate.m** file:

#### Objective-C:
```objective-c
[[PKAuth sharedInstance] setAPISecret:@"YOUR_APPLICATION_SECRET"];
[[PKAuth sharedInstance] setClientID:@"YOUR_CLIENT_ID"];
[[PKAuth sharedInstance] setRedirectURI:@"YOUR_CALLBACK_URL"];
```

#### Swift:
```swift
Auth.shared().apiSecret = "YOUR_API_KEY"
Auth.shared().clientId = "YOUR_CLIENT_ID"
Auth.shared().redirectURI = "YOUR_CALLBACK_URL"
```

## License

PutIOKit is released under the MIT license. See [LICENSE](https://github.com/mourke/PutIOKit/blob/master/LICENSE) for details.
