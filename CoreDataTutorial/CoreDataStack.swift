//
//  CoreDataStack.swift
//  CoreDataTutorial
//
//  Created by Pyae Phyo Oo on 10/11/22.
//  Copyright © 2022 James Rochabrun. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataTutorial")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
    
    func clearData( enitity: String) {
            do {
                let context = CoreDataStack.shared.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enitity)
                do {
                    let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                    _ = objects.map{$0.map{context.delete($0)}}
                    CoreDataStack.shared.saveContext()
                } catch let error {
                    print("ERROR DELETING : \(error)")
                }
            }
        }
    
    //    func fetch<T: NSManagedObject>(name: String, _ type: T.Type, completion: @escaping (T) -> Void) {
    //        let context = self.persistentContainer.viewContext
    //        if let newEntity = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as? T {
    //            newEntity
    //        }
    //    }
}
