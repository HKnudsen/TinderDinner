//
//  ViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 07/02/2021.
//

import UIKit
import CoreData

class CardViewController: UIViewController {

    @IBOutlet weak var isMultipleUsersSwith: UISwitch!
    
    var databaseManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let request: NSFetchRequest<Dinner> = Dinner.fetchRequest()
        // Predicate & Sort descriptor doesnt work. - EXC_BAD_ACCESS (code=1, address=0x0)
        //request.predicate = NSPredicate(format: "ingredients CONTAINS[cd] %@", "Milk")
//        request.sortDescriptors = [NSSortDescriptor(key: "ingredients", ascending: true)]
        
        do { databaseManager.items = try databaseManager.context.fetch(request)}
        catch let error { print(error) }
        
        databaseManager.addNewIngredient(ingredient: "Dough")
        databaseManager.loadItems()
        databaseManager.removeDinnersWith(filter: databaseManager.unwantedIngredients!)
        
        
        
        
        
    }
    
    func requestPredicateTest() {
        
    }
    
    func addDinnerTest() {
        let dinner = Dinner(context: databaseManager.context)
        dinner.ingredients = ["Milk", "Dough"]
        dinner.name = "Second Best Dinner"
        dinner.origin = "Sweeden"
        
        do { try databaseManager.context.save() }
        catch let error { print(error) }
    }


}

