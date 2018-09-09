# ImageSizeFetcher
### Finds the size or type of an image given its uri by fetching as little as needed

[![Version](https://img.shields.io/cocoapods/v/ImageSizeFetcher.svg?style=flat)](http://cocoadocs.org/docsets/ImageSizeFetcher) [![License](https://img.shields.io/cocoapods/l/ImageSizeFetcher.svg?style=flat)](http://cocoadocs.org/docsets/ImageSizeFetcher) [![Platform](https://img.shields.io/cocoapods/p/ImageSizeFetcher.svg?style=flat)](http://cocoadocs.org/docsets/ImageSizeFetcher)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ImageSizeFetcher.svg)](https://img.shields.io/cocoapods/v/ImageSizeFetcher.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/twitter-@danielemargutti-blue.svg?style=flat)](http://twitter.com/danielemargutti)

<p align="center" >★★ <b>Star me to follow the project! </b> ★★<br>
Created by <b>Daniele Margutti</b> - <a href="http://www.danielemargutti.com">danielemargutti.com</a>
</p>

## What's ImageSizeFetcher

Your app needs to find the size or type of an image but it's  not locally stored – it’s on another asset server, or in the cloud (Amazon S3 for example); your webservice does not expose the size via APIs.

You don’t want to download the entire image to your app server – it could be many tens of kilobytes, or even megabytes just to get this information.

Moreover you can't wait the download of all images to adjust your layout (ie. UICollectionView/UITableView) and you can't do it incrementally without incur in a poor UX experience for your user.

For most common image types (GIF, PNG, BMP etc.), the size of the image is simply stored at the start of the file. For JPEG files it’s a little bit more complex, but even so you do not need to fetch much of the image to find the size.

ImageSizeFetcher does this minimal fetch just downloade few kb and doesn’t rely on installing external libraries; it's just in pure Swift.

## Supported Formats

Currently ImageSizeFetcher supports the most common formats you can use in your app:

- PNG
- GIF
- JPEG
- BMP

In most cases the the downloaded data is below 50 KB.

## How it works

If you are interested in knowing more about how it works I wrote an article you can found on my blog:

["Prefetching images size without downloading them [entirely] in Swift"](http://www.danielemargutti.com)

To use it you just need to instantiate (and keep a strong reference) to the `ImageSizeFetcher` class. It supports a local in-memory cache of the request and has a GCD queue to manage multiple request automatically; you just need to call the `sizeFor()` method:

```swift
let imageURL: URL = ...
fetcher.sizeFor(atURL: $0.url) { (err, result) in
  // error check...
  print("Image size is \(NSStringFromCGSize(result.size))")
}
```

## Unit Tests

Unit tests are available inside the `Tests` folder.

## Requirements

ImageSizeFetcher is compatible with Swift 4.x.

* iOS 8.0+
* macOS 10.9+
* tvOS 9.0+
* watchOS 2.0+

## Issues & Contributions

Please [open an issue here on GitHub](https://github.com/malcommac/ImageSizeFetcher/issues/new) if you have a problem, suggestion, or other comment.
Pull requests are welcome and encouraged.

## Installation

### Install via CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager which automates and simplifies the process of using 3rd-party libraries like ImageSizeFetcher in your projects. You can install it with the following command:

```bash
$ sudo gem install cocoapods
```

> CocoaPods 1.0.1+ is required to build ImageSizeFetcher.

#### Install via Podfile

To integrate ImageSizeFetcher into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
use_frameworks!
pod 'ImageSizeFetcher'
end
```

Then, run the following command:

```bash
$ pod install
```

<a name="carthage" />

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ImageSizeFetcher into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "malcommac/ImageSizeFetcher"
```

Run `carthage` to build the framework and drag the built `ImageSizeFetcher.framework` into your Xcode project.

## Copyright

ImageSizeFetcher is available under the MIT license. See the LICENSE file for more info.

Daniele Margutti: [hello@danielemargutti.com](mailto:hello@danielemargutti.com)

Twitter: [@danielemargutti](https://twitter.com/danielemargutti)
