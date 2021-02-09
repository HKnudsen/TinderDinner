//
//  Dinner+CoreDataProperties.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 09/02/2021.
//
//

import Foundation
import CoreData


extension Dinner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dinner> {
        return NSFetchRequest<Dinner>(entityName: "Dinner")
    }

    @NSManaged public var ingredients: [NSString]?
    @NSManaged public var name: String?
    @NSManaged public var origin: String?

}

extension Dinner : Identifiable {

}
