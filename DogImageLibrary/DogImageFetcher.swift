//
//  DogImageLibrary.swift
//  DogImageLibrary
//
//  Created by Bhawanisingh Rao on 15/08/24.
//

import Foundation
import UIKit

public protocol DogImageDelegate {
    func showHideloader(_ loading:Bool)
    func didRecieveError(msg:String)
}

public class DogImageFetcher{
    private let  coreDataManager =  CoreDataManager.shared
    public var delegate: DogImageDelegate?
    var images:[UIImage] = []
    var currentIndex = -1
    public init(){
        images = coreDataManager.fetchAllImages()
    }
    public func getImage(completion: @escaping (UIImage?) -> Void ){
        guard self.images.isEmpty else {
            currentIndex = 0
            completion(images.first)
            return
        }
        delegate?.showHideloader(true)
        fetchImage{ [weak self] images in
            guard let self = self else { return }
            self.delegate?.showHideloader(false)
            completion(images?.first as? UIImage)
        }
    }
    
    public func getNextImage(completion: @escaping (UIImage) -> Void ){
        if currentIndex < images.count - 1{
            currentIndex += 1
            completion(images[currentIndex])
        }else{
            delegate?.showHideloader(true)
            fetchImage { [weak self] fetchedImages in
                guard let self = self else { return }
                self.delegate?.showHideloader(false)
                
                if let fetchedImage = fetchedImages?.first as? UIImage {
                    self.currentIndex += 1
                    completion(fetchedImage)
                } else {
                    // Handle the case where fetching fails or returns no valid image
                    self.delegate?.didRecieveError(msg:"Error in Fetching Image")
                }
            }
        }
    }
    
    public func getPreviousImage() -> (image:UIImage?,isEnable:Bool){
        guard currentIndex > 0 else {
            return (nil, false)
        }
        
        currentIndex -= 1
        
        let image = images[currentIndex]  // Using a safe array access method
        let isEnable = currentIndex > 0
        
        return (image, isEnable)
    }
    
    public func getImage(number: Int,completion:@escaping ([UIImage?]?) -> Void){
        delegate?.showHideloader(true)
        fetchImage(number){[weak self] images in
            self?.delegate?.showHideloader(false)
            completion(images)
        }
    }
    
    fileprivate func downloadImage(_ imageURLStr: String, _ completion: @escaping (Result<UIImage?,Error>) -> Void ) {
        
        DogImageService.shared.downloadImage(urlString: imageURLStr) {result in
            completion(result)
        }
    }
    
    fileprivate func fetchImage(_ number: Int? = nil, completion: @escaping ([UIImage?]?) -> Void) {
        DogImageService.shared.fetchDogImage(number) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dogImage):
                if let imageUrlStr = dogImage.message.asString {
                    downloadImage(imageUrlStr) { [weak self] result in
                        guard let self = self else { return }
                        switch result{
                        case .success(let image):
                            if let image{
                                self.coreDataManager.saveImageData(image)
                            }
                            self.images = self.coreDataManager.fetchAllImages()
                            completion([image])
                        case.failure(let error):
                            self.delegate?.didRecieveError(msg: error.localizedDescription)
                        }
                    }
                }else if let imageURLArray = dogImage.message.asArray{
                    var imageArray = [UIImage]()
                    let dispatchGroup = DispatchGroup()
                    var hasError: Error?
                    let queue = DispatchQueue(label: "DownloadTask")
                    var workItems = [DispatchWorkItem]()
                    let imageArraylock = NSLock()
                    for imageURLStr in imageURLArray{
                        dispatchGroup.enter()
                        let workItem = DispatchWorkItem {
                            if hasError != nil {
                                dispatchGroup.leave()
                                return
                            }
                            self.downloadImage(imageURLStr) { result in
                                switch result {
                                case .success(let image):
                                    if let image{
                                        imageArraylock.lock()
                                        imageArray.append(image)
                                        imageArraylock.unlock()
                                    }
                                case .failure(let error):
                                    hasError = error
                                    workItems.forEach { workItem in
                                        workItem.cancel()
                                    }
                                }
                                dispatchGroup.leave()
                            }
                        }
                        if !workItem.isCancelled {
                            queue.async(execute: workItem)
                            workItems.append(workItem)
                        }
                    }
                    dispatchGroup.notify(queue: .global()) {
                        if let hasError {
                            self.delegate?.didRecieveError(msg: hasError.localizedDescription)
                        }else{
                            completion(imageArray)
                        }
                        
                    }
                    
                }
                break
            case .failure(let error):
                self.delegate?.didRecieveError(msg: error.localizedDescription)
                break
            }
        }
    }
}
