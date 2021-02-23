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
    
    func loadItems(with request: NSFetchRequest<Dinner> = Dinner.fetchRequest()) {
        do { items = try context.fetch(request) }
        catch let error { print("Error getting data with fetch request: \(error)") }
    }
    
    func addDinnerToFavourites(with Dinner: String) {
        print("Added to favourites")
    }
}
