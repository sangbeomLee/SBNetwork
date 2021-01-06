# SBNetwork

[![CI Status](https://img.shields.io/travis/sangbeomLee/SBNetwork.svg?style=flat)](https://travis-ci.org/sangbeomLee/SBNetwork)
[![Version](https://img.shields.io/cocoapods/v/SBNetwork.svg?style=flat)](https://cocoapods.org/pods/SBNetwork)
[![License](https://img.shields.io/cocoapods/l/SBNetwork.svg?style=flat)](https://cocoapods.org/pods/SBNetwork)
[![Platform](https://img.shields.io/cocoapods/p/SBNetwork.svg?style=flat)](https://cocoapods.org/pods/SBNetwork)

## Description

네트워크 처리를 도와줍니다.
image 에 대한 캐시처리를 지원합니다.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
// imageView 에 이미지르 바로 set
imageView.setImage(from: someURL, showsIndicator = true)

// ImageManager 를 통한 image 가져오는 방법
SBImageManager.shared.fetch(url) { result in
            switch result {
            case .success(let image):
                ...
            case .failure(let error):
                ...
            }
        }

```

## Requirements

## Installation

SBNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SBNetwork'
```

## Author

sangbeomLee, wing951@naver.com

## License

SBNetwork is available under the MIT license. See the LICENSE file for more info.
