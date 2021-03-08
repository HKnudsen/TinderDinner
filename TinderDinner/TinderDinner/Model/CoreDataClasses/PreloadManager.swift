//
//  PreloadManager.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 07/03/2021.
//

import UIKit

struct dinnerStructure {
    var ingredients: [String]
    var name: String
    var origin: String
    var howToMake: [String]
    var allergens: String
    var uniqueID: Int64
    var image: Data
}

class PreloadManager {
    private var dbManager = DatabaseManager.shared
    
    private let dinnerList: [dinnerStructure] = [
        dinnerStructure(ingredients: ["Water", "Milk", "Salt"], name: "Norwegian Dinner", origin: "Norway", howToMake: ["Makemake", "Donedone", "done"], allergens: "Dairy", uniqueID: 1, image: (UIImage(named: "ironman1")?.pngData())!),
        dinnerStructure(ingredients: ["Dough", "Milk", "Shake"], name: "Sweedish Dinner", origin: "Sweeden", howToMake: ["Mademade", "DoneDone"], allergens: "Dairy;Gluten", uniqueID: 2, image: (UIImage(named: "ironman2")?.pngData())!),
        dinnerStructure(ingredients: ["Dough", "Salt", "Milk"], name: "Danish Dinner", origin: "Denmark", howToMake: ["Makemake", "taketake", "done"], allergens: "Dairy;Gluten", uniqueID: 3, image: (UIImage(named: "test")?.pngData())!),
        dinnerStructure(ingredients: ["Milk", "Salt"], name: "Finnish Dinner", origin: "Finland", howToMake: ["Makemake", "done"], allergens: "Dairy", uniqueID: 4, image: (UIImage(named: "ironman2")?.pngData())!),
        dinnerStructure(ingredients: ["Oregano", "Cheese"], name: "Italian Pizza", origin: "Italy", howToMake: ["Cheese cheese", "cook cook", "dine done"], allergens: "Dairy;Gluten", uniqueID: 5, image: (UIImage(named: "ironman1")?.pngData())!)
    ]
    
    func checkIfPreloaded() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "First Launch") == true {
            print("Not First Launch")
            defaults.setValue(true, forKey: "First Launch")
        } else {
            print("First Launch")
            preLoadDinners()
            defaults.setValue(true, forKey: "First Launch")
        }
    }
    
    private func preLoadDinners() {
        
        for dinner in dinnerList {
            var dinnerToPreload = Dinner(context: dbManager.context)
            dinnerToPreload.ingredients = dinner.ingredients
            dinnerToPreload.allergens = dinner.allergens
            dinnerToPreload.name = dinner.name
            dinnerToPreload.howToMake = dinner.howToMake
            dinnerToPreload.image = dinner.image
            dinnerToPreload.uniqueID = dinner.uniqueID
            print("PRELOADDINNER\(dinnerToPreload)")
            
            do { try dbManager.context.save() }
            catch let error { print("Error preloading data from PreloadManager: \(error)") }
        }
        
    }
}
