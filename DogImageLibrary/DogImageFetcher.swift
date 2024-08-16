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
            currentIndex = 1
            completion(images.first)
            return
        }
        delegate?.showHideloader(true)
        fetchImage{ [weak self]images in
            self?.delegate?.showHideloader(false)
            completion(images?.first as? UIImage)
        }
    }
    
    public func getNextImage(completion: @escaping (UIImage) -> Void ){
        if currentIndex < images.count - 1{
            currentIndex += 1
            completion(images[currentIndex])
        }else{
            delegate?.showHideloader(true)
            fetchImage{[weak self] images in
                self?.delegate?.showHideloader(false)
                if let image = images?.first as? UIImage {
                    self?.currentIndex += 1
                    completion(image)
                }
            }
        }
    }
    
    public func getPreviousImage() -> (image:UIImage?,isEnable:Bool){
        if currentIndex <= 0 {
            return (nil,false)
        }else{
            currentIndex -= 1
            return (images[currentIndex],currentIndex == 0 ? false : true )
        }
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
                        switch result{
                        case .success(let image):
                            if let image{
                                self?.coreDataManager.saveImageData(image)
                            }
                            self?.images = self?.coreDataManager.fetchAllImages() ?? []
                            print(self?.images.count ?? 0)
                            completion([image])
                        case.failure(let error):
                            self?.delegate?.didRecieveError(msg: error.localizedDescription)
                        }
                    }
                }else if let imageURLArray = dogImage.message.asArray{
                    var imageArray = [UIImage]()
                    let dispatchGroup = DispatchGroup()
                    var hasError: Error?
                    for imageURLStr in imageURLArray{
                        dispatchGroup.enter()
                        downloadImage(imageURLStr) { result in
                            switch result {
                            case .success(let image):
                                if let image{
                                    imageArray.append(image)
                                }
                            case .failure(let error):
                                hasError = error
                            }
                            dispatchGroup.leave()
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
