//
//  ManagedBrewery+CoreDataProperties.swift
//  BreweryApp
//
//  Created by Stanislav on 04.04.2021.
//
//

import Foundation
import CoreData


extension ManagedBrewery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedBrewery> {
        return NSFetchRequest<ManagedBrewery>(entityName: "ManagedBrewery")
    }

    @NSManaged public var descriptionBrewery: String?
    @NSManaged public var imageBrewery: Data?
    @NSManaged public var nameBrewery: String?
    @NSManaged public var rowsBeerGrade: NSSet?

}

// MARK: Generated accessors for rowsBeerGrade
extension ManagedBrewery {

    @objc(addRowsBeerGradeObject:)
    @NSManaged public func addToRowsBeerGrade(_ value: ManagedBeersGrades)

    @objc(removeRowsBeerGradeObject:)
    @NSManaged public func removeFromRowsBeerGrade(_ value: ManagedBeersGrades)

    @objc(addRowsBeerGrade:)
    @NSManaged public func addToRowsBeerGrade(_ values: NSSet)

    @objc(removeRowsBeerGrade:)
    @NSManaged public func removeFromRowsBeerGrade(_ values: NSSet)

}

extension ManagedBrewery : Identifiable {

}
