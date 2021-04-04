//
//  ManagedBeersGrades+CoreDataProperties.swift
//  BreweryApp
//
//  Created by Stanislav on 04.04.2021.
//
//

import Foundation
import CoreData


extension ManagedBeersGrades {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedBeersGrades> {
        return NSFetchRequest<ManagedBeersGrades>(entityName: "ManagedBeersGrades")
    }

    @NSManaged public var descriptionBG: String?
    @NSManaged public var imageBG: Data?
    @NSManaged public var nameBG: String?
    @NSManaged public var brewery: ManagedBrewery?

}

extension ManagedBeersGrades : Identifiable {

}
