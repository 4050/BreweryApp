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
    func getBeersGrades() -> [ManagedBeersGrades]
    func saveBrewery(brewery: Brewery)
    func saveBeerGrade(beerGrade: BeerGrade, brewery: ManagedBrewery)
}

class BreweryStorageService: PersistenceStore {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.storageBrewery)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    lazy var backgroundMOC = persistentContainer.newBackgroundContext()
    
    var fetchedResultsController: NSFetchedResultsController<ManagedBrewery>!
    
    func getBreweries() -> [ManagedBrewery] {
        context.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.managedBrewery)
        do {
            guard let fetchedObjects =
                    try context.fetch(fetchRequest) as? [ManagedBrewery] else { return [ManagedBrewery]() }
            return fetchedObjects
        } catch {
            print(error.localizedDescription)
            return [ManagedBrewery]()
        }
    }
    
    func getBeersGrades() -> [ManagedBeersGrades] {
        context.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.managedBeersGrades)
        do {
            guard let fetchedObjects =
                    try context.fetch(fetchRequest) as? [ManagedBeersGrades] else { return [ManagedBeersGrades()] }
            return fetchedObjects
        } catch {
            print(error.localizedDescription)
            return [ManagedBeersGrades]()
        }
    }
    
    func saveBeerGrade(beerGrade: BeerGrade, brewery: ManagedBrewery) {
        let beer = NSEntityDescription.insertNewObject(forEntityName: Constants.managedBeersGrades, into: context) as! ManagedBeersGrades
        backgroundMOC.performAndWait {
            beer.brewery = brewery
            beer.imageBG = beerGrade.image
            beer.nameBG = beerGrade.name
            beer.descriptionBG = beerGrade.description
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func saveBrewery(brewery: Brewery) {
        guard let entity =
                NSEntityDescription.entity(forEntityName: Constants.managedBrewery, in: context) else { return }
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


