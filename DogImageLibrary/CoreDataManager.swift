//
//  CoreDataManager.swift
//  DogImageLibrary
//
//  Created by Bhawanisingh Rao on 15/08/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    static let shared = CoreDataManager()
    let identifier: String  = "com.CleverTap.DogImageLibrary"
    let model: String       = "DogImageModel"
    lazy var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        
        return container
    }()
    func saveImageData (_ image:UIImage) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "DogImageEntity", into: context) as! DogImageEntity
        entity.id = UUID()
        entity.dogImage = image.pngData()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func fetchAllImages() ->  [UIImage]{
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<DogImageEntity>(entityName: "DogImageEntity")
        var images = [UIImage]()
        
        do{
            
            let dogImageEntity = try context.fetch(fetchRequest)
            
            for (index,entity) in dogImageEntity.enumerated() {
                if let imageData = entity.dogImage {
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
            }
            
        }catch let fetchErr {
            print("❌ Failed to fetch Person:",fetchErr)
        }
        return images
    }
}
