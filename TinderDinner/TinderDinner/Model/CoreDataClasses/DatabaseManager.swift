//
//  DatabaseManager.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 08/02/2021.
//

import UIKit
import CoreData

// Manages FetchRequests and results to the CoreData local backend

struct DatabaseManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Dinner]?
    var selectedIngredients: [String]?
    
    // TODO: Refactor predicate to search for ingredients instead of dinner names
    func filterDinners(text: String) -> NSFetchRequest<Dinner> {
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    func filterIngredients() {
        
    }
    
    mutating func loadItems(with request: NSFetchRequest<Dinner> = Dinner.fetchRequest()) {
        do { items = try context.fetch(request) }
        catch let error { print("Error getting data with fetch request: \(error)") }
    }
}
