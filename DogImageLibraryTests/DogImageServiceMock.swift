//
//  DogImageServiceMock.swift
//  DogImageLibraryTests
//
//  Created by Bhawanisingh Rao on 16/08/24.
//

@testable import DogImageLibrary
import UIKit

class DogImageServiceMock: DogImageService {
    static var result: Result<DogImage, Error>?
    static var downloadResult: Result<UIImage?, Error>?
    
    override func fetchDogImage(_ number: Int?, completion: @escaping (Result<DogImage, any Error>) -> Void) {
        if let result = DogImageServiceMock.result{
            completion(result)
        }
    }

    
    override func downloadImage(urlString: String, completion: @escaping (Result<UIImage?, any Error>) -> Void) {
        if let result = DogImageServiceMock.downloadResult {
            completion(result)
        }
    }
}

