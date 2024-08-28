# DogImageLibrary

A lightweight library for fetching dog images from a URL.

## Installation

`DogImageLibrary` is available through CocoaPods. To integrate it into your Xcode project, add the following line to your `Podfile`:

```ruby
target 'YourAppTarget' do
  pod 'DogImageLibrary'
end
```
## Then, run the following command in your terminal:



```bash
pod install
```
## Integration in Your App

Import the Library:

```swift
import DogImageLibrary
```
## Initialize the Image Fetcher:

```swift
let imageFetcher = DogImageFetcher()
```
## Set the Delegate:
Make sure your class conforms to DogImageFetcherDelegate to handle loading and error states:

```swift
imageFetcher.delegate = self
```
Fetch the First Image:

```swift
imageFetcher.getImage { image in
    // Handle the fetched image
}
```
Fetch the Next Image:

```swift
imageFetcher.getNextImage { image in
    // Handle the next image
}
```
Fetch the Previous Image:

```swift
let (image, isPrevEnabled) = imageFetcher.getPreviousImage()

if let image = image {
    self.imageView.image = image
}
self.prevBtn.isEnabled = isPrevEnabled
```
Fetch Multiple Images:
Fetch a specified number of dog images:

```swift
imageFetcher.getImage(number: num) { images in
    // Handle the array of images
}
```
Delegate Methods

Show/Hide Loading View
Implement this delegate method to control the loading indicator:



```swift
func showHideloader(_ loading: Bool) {
    // Show or hide the loader based on the loading state
}
```
Error Handling
Handle errors with this delegate method:



```swift
func didRecieveError(msg: String) {
    // Handle the error message
}
```
## Xcode Project Configuration

```
To use DogImageLibrary, update your Xcode project’s build setting ENABLE_USER_SCRIPT_SANDBOXING to No.

How to Update ENABLE_USER_SCRIPT_SANDBOXING:
In Xcode, click the search icon tab in the left-hand panel.
Ensure the search scope is set to the 'Runner' workspace.
Search for ENABLE_USER_SCRIPT_SANDBOXING.
Set the value to No
```
