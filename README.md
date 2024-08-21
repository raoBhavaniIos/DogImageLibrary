# DogImageLibrary
Library for fetching images from URL
## Installation
> DogImageLibrary is available through CocoaPods. To install it, simply add the following line to your Podfile
```
target 'YourAppTarget' do
  pod 'DogImageLibrary'
end
```
> Run below Command in the Terminal
 ```
pod install
 ```
## Integration in App
```
import DogImageLibrary

let imageFatchLibrary: DogImageFetcher = DogImageFetcher()

//  confirm to Delegate 
imageFatch.delegate = self 

// fetch the first image from the Library
imageFatch.getImage { image in
            
        }

// Fetch NextImage
imageFatch.getNextImage { image in
                
        }

// gets PreviousImage and bool for the previous image present 
let (image, isPrevEnable) = imageFatch.getPreviousImage()
        
        if let image = tuple.image {
                self.imageView.image = image
            }
            self.prevBtn.isEnabled = tuple.isEnable

//Gets the number of dog images randomly from the API  
 imageFatch.getImage(number: num) {  images in
}

// Delegate methods for if the user wants to show hide loading view
func showHideloader(_ loading: Bool) {}

// Delegate methods for error handling
func didRecieveError(msg: String) {}        
```

##  Update your Xcode project build option ENABLE_USER_SCRIPT_SANDBOXING to 'No'.
### To find the 'ENABLE_USER_SCRIPT_SANDBOXING' go to the Search icon tab in the left-hand panel within Xcode. Ensure you are searching within the 'Runner' workspace, configure the search to ignore the text, and then press enter to search with text 'ENABLE_USER_SCRIPT_SANDBOXING'

