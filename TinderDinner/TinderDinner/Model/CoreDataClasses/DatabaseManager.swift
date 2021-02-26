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
    
    var wantedDinners: [Dinner]?
    
    let allAllergens = ["Dairy", "Gluten"]
    var allergensState: NSMutableDictionary?
    
//    func removeDinnersWith(filter: [String]) {
//        if var items = items {
//            for (i, dinner) in items.enumerated() {
//                if let unwantedIngredients = unwantedIngredients, let ingredientsInDinner = dinner.ingredients {
//                    for (k, _) in unwantedIngredients.enumerated() {
//                        if ingredientsInDinner.contains(unwantedIngredients[k]) {
//                            items.remove(at: i)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func addToWantedDinner(with dinner: Dinner) {
        if self.wantedDinners == nil {
            self.wantedDinners = [dinner]
        } else {
            self.wantedDinners?.append(dinner)
        }
    }

    
    
//    func removeIngredient(ingredient: String) {
//        if unwantedIngredients != nil {
//            guard let indexOfIngredient = unwantedIngredients?.firstIndex(of: ingredient) else {
//                fatalError("Error getting index of ingredient") }
//            unwantedIngredients?.remove(at: indexOfIngredient)
//        } else {
//            print("Trying to remove ingredient from empty array")
//        }
//    }
    
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
    
    func filterWithMultipleAllergens() {
        var predicates = [NSPredicate]()

        for (key, value) in allergensState! {
            if value as! Int == 0 {
                let predicate = NSPredicate(format: "NOT (allergens CONTAINS[cd] %@)", key as! CVarArg)
                predicates.append(predicate)
            } else if value as! Int == 0 {
                print("\(key): \(value)")
            }
        }

        var compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        request.predicate = compoundPredicate
        loadItems(with: request)
        print("SE HER 3 : \(items?.count)")
        
        
        
    }
    
    func prepareCompoundPredicateFilter() {
        
    }
    
    func testNotContain() {
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        let predicate = NSPredicate(format: "NOT %K CONTAINS %@", "name", "Second Best Dinner")
        request.predicate = predicate
        loadItems(with: request)
    }
    

    
    
    
    // MARK: - Plist Section
    // This has to be called to load the plist data to the database manager
    func loadAllergensPlistData() {
        //Plist location
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsInDirectory = paths.object(at: 0) as! NSString
        let path = documentsInDirectory.appendingPathComponent("allergens.plist")
        let fileManager = FileManager.default
        
        //Check if file exists
        if !fileManager.fileExists(atPath: path) {
            guard let bundlePath = Bundle.main.path(forResource: "allergens", ofType: "plist") else { return }
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: path)
            } catch let error as NSError {
                print("Unable to copy file: \(error.localizedDescription)")
            }
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print(resultDictionary?.description ?? "")
        
        let myDict = NSMutableDictionary(contentsOfFile: path)
        if let dict = myDict {
            print(dict.object(forKey: "Gluten"))
            print(dict.object(forKey: "Dairy"))
            print(dict.object(forKey: "Soy"))
        }
        
        print(myDict)
        self.allergensState = myDict
    }
    
    func editAllergenPlistData(allergen: String) {
        //Plist location
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsInDirectory = paths.object(at: 0) as! NSString
        let path = documentsInDirectory.appendingPathComponent("allergens.plist")
        let fileManager = FileManager.default
        
        var dictionary = NSMutableDictionary(contentsOfFile: path)
        
        if dictionary?.object(forKey: allergen) as! Int == 0 {
            dictionary?.setValue(1, forKey: allergen)
            allergensState?.setValue(1, forKey: allergen)
        } else if dictionary?.object(forKey: allergen) as! Int == 1 {
            dictionary?.setValue(0, forKey: allergen)
            allergensState?.setValue(0, forKey: allergen)
        }
        
        dictionary?.write(toFile: path, atomically: true)
    }
    
    
}
