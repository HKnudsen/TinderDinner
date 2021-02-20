//
//  Dinner+CoreDataProperties.swift
//  
//
//  Created by Henrik Bouwer Knudsen on 20/02/2021.
//
//

import Foundation
import CoreData


extension Dinner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dinner> {
        return NSFetchRequest<Dinner>(entityName: "Dinner")
    }

    @NSManaged public var howToMake: [String]?
    @NSManaged public var ingredients: [String]?
    @NSManaged public var name: String?
    @NSManaged public var origin: String?

}
