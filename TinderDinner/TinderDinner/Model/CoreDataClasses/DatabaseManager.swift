//
//  DatabaseManager.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 08/02/2021.
//

import UIKit
import CoreData

// Manages FetchRequests and results to the CoreData local backend

class DatabaseManager {
    static let shared = DatabaseManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Dinner]?
    var unwantedIngredients: [String]?
    var wantedDinners: [Dinner]?
    var unwantedAllergens: [String]?
    let allAllergens = ["Dairy", "Gluten"]
    
    func removeDinnersWith(filter: [String]) {
        if var items = items {
            for (i, dinner) in items.enumerated() {
                if let unwantedIngredients = unwantedIngredients, let ingredientsInDinner = dinner.ingredients {
                    for (k, _) in unwantedIngredients.enumerated() {
                        if ingredientsInDinner.contains(unwantedIngredients[k]) {
                            items.remove(at: i)
                        }
                    }
                }
            }
        }
    }
    
    func addToWantedDinner(with dinner: Dinner) {
        if self.wantedDinners == nil {
            self.wantedDinners = [dinner]
        } else {
            self.wantedDinners?.append(dinner)
        }
    }
    
    func addNewIngredient(ingredient: String) {
        if self.unwantedIngredients == nil {
            self.unwantedIngredients = [ingredient]
        } else {
            self.unwantedIngredients?.append(ingredient)
        }
    }
    
    func removeIngredient(ingredient: String) {
        if unwantedIngredients != nil {
            guard let indexOfIngredient = unwantedIngredients?.firstIndex(of: ingredient) else {
                fatalError("Error getting index of ingredient") }
            unwantedIngredients?.remove(at: indexOfIngredient)
        } else {
            print("Trying to remove ingredient from empty array")
        }
    }
    
    func exactSearchWithNSPredicate(attribute: String, text: String) {
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        let predicate = NSPredicate(format: "\(attribute) == %@", text)
        request.predicate = predicate
        loadItems(with: request)
    }
    
    func containsSearchWithNSPredicate(attribute: String, text: String) {
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        let predicate = NSPredicate(format: "\(attribute) CONTAINS[cd] %@", text)
        request.predicate = predicate
        loadItems(with: request)
    }
    
    func loadItems(with request: NSFetchRequest<Dinner> = Dinner.fetchRequest()) {
        do { items = try context.fetch(request) }
        catch let error { print("Error getting data with fetch request: \(error)") }
    }
    
    func addDinnerToFavourites(with Dinner: String) {
        print("Added to favourites")
    }
    
    func doesNotContain(attribute: String = "allergens", text: String) {
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        let predicate = NSPredicate(format:"NOT (%K CONTAINS[cd] %@)",attribute, text)
        request.predicate = predicate
        do { items = try context.fetch(request) }
        catch let error { print("Error: \(error)") }
//        loadItems(with: request)
    }
    
    func filterWithMultipleAllergens(allergens: [String]) {
        var predicates = [NSPredicate]()
        for allergen in allergens {
            var predicate = NSPredicate(format: "NOT (allergens CONTAINS[cd] %@)", allergen)
            predicates.append(predicate)
        }

        var compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        request.predicate = compoundPredicate
        loadItems(with: request)
        
        
        
    }
    
    func testNotContain() {
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        let predicate = NSPredicate(format: "NOT %K CONTAINS %@", "name", "Second Best Dinner")
        request.predicate = predicate
        loadItems(with: request)
    }
}
