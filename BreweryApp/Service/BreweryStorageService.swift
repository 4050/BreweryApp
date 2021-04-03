//
//  BreweryStorageService.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import Foundation
import CoreData

protocol PersistenceStore {
    func getBreweries() -> [ManagedBrewery]
    func saveBrewery(brewery: Brewery)
}

class BreweryStorageService: PersistenceStore {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StorageBrewery")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    lazy var backgroundMOC = persistentContainer.newBackgroundContext()
    
    func getBreweries() -> [ManagedBrewery] {
        context.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedBrewery")
        do {
            guard let fetchedObjects =
                    try context.fetch(fetchRequest) as? [ManagedBrewery] else { return [ManagedBrewery]() }
            return fetchedObjects
        } catch {
            print(error.localizedDescription)
            return [ManagedBrewery]()
        }
    }
    
    func saveBrewery(brewery: Brewery) {
        guard let entity =
                NSEntityDescription.entity(forEntityName: "ManagedBrewery", in: context) else { return }
        guard let taskObject =
                NSManagedObject(entity: entity, insertInto: backgroundMOC) as? ManagedBrewery else { return }
        backgroundMOC.performAndWait {
            taskObject.imageBrewery = brewery.image
            taskObject.nameBrewery = brewery.name
            taskObject.descriptionBrewery = brewery.description
            do {
                try backgroundMOC.save()
            } catch {
                print(error)
            }
        }
    }
}


