[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/vsouza/awesome-ios)
[![License](https://img.shields.io/cocoapods/l/FaceCropImageView.svg?style=flat)](https://cocoapods.org/pods/FaceCropImageView)
[![Platform](https://img.shields.io/cocoapods/p/FaceCropImageView.svg?style=flat)](https://cocoapods.org/pods/FaceCropImageView)

## Face Crop ImageView
This FaceCropImageView is an extension of UIImageView, which helps properly crop and show the position of the face in the picture. This library is strongly inspired by [UIImageView-BetterFace](https://github.com/croath/UIImageView-BetterFace).

Demo screenshot and description are here!

<img src="https://raw.githubusercontent.com/HanSJin/FaceCropImageView/master/Example/Images/demo-explain.jpg">

## Installation

FaceCropImageView is available through [CocoaPods](https://cocoapods.org/pods/FaceCropImageView). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FaceCropImageView'
```
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

Simple instruction is explained as follows.

```Swift
let myImage = UIImage(named: "some-image")
imageView.setFaceImage(imageUrl)
```

You can also crop the image on the web using the URL. (In this case, the Kingfis her library is used)(https://github.com/onevcat/Kingfisher) library is used)

```Swift
let imageUrl = URL(string: "https://some-url/image.jpg")
imageView.setFaceImage(with: imageUrl)
```

If you need to detect faces more specifically, use `fast` parameter.
This parameter can determine the value of `CIDectorAccuracy` from CIDectorAccuracyLow to CIDectorAccuracyHigh.


```Swift
imageView.setFaceImage(with: imageUrl, fast: false)
```

And it supports the completion closure.

```Swift
imageView.setFaceImage(with: imageUrl, fast: false) { result in
    switch result {
    case .success(let features):
        // `feature` means detected face infomation.
        // `features.count == 0` means no face in the image.
        print(features)
    case .failure(let error):
        print(error)
    }
}
```


## Author

HanSJin, kksd9900@naver.com

## License

FaceCropImageView is available under the MIT license. See the LICENSE file for more info.
