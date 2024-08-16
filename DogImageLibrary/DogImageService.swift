//
//  DogImageService.swift
//  DogImageLibrary
//
//  Created by Bhawanisingh Rao on 15/08/24.
//

import Foundation
import UIKit

 class DogImageService {
    
    public static let shared = DogImageService()
    private var baseURL = "https://dog.ceo/api/breeds/image/random"
    
    private init() {}
    
     func fetchDogImage(_ number:Int?,completion: @escaping (Result<DogImage, Error>) -> Void) {
        var urlStr = baseURL
        if let number {
            urlStr = urlStr + "/\(number)"
        }
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let dogImage = try JSONDecoder().decode(DogImage.self, from: data)
                completion(.success(dogImage))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func downloadImage(urlString: String, completion: @escaping (Result<UIImage?,Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid image URL", code: 500)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(.failure(error ?? NSError(domain: "Image Data invalid", code: 501)))
                return
            }
            completion(.success(image))
        }.resume()
    }
    
}


