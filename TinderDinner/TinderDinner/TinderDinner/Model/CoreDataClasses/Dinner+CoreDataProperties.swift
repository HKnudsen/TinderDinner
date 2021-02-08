//
//  Dinner+CoreDataProperties.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 08/02/2021.
//
//

import Foundation
import CoreData


extension Dinner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dinner> {
        return NSFetchRequest<Dinner>(entityName: "Dinner")
    }

    @NSManaged public var origin: String?
    @NSManaged public var ingredients: [String]?

}

extension Dinner : Identifiable {

}
