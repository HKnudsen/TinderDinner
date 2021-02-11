//
//  ViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 07/02/2021.
//

import UIKit
import CoreData
import Koloda

class CardViewController: UIViewController {

    @IBOutlet weak var cardView: KolodaView!
    @IBOutlet weak var isMultipleUsersSwith: UISwitch!
    
    var databaseManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardView.delegate = self
        cardView.dataSource = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
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

extension CardViewController: KolodaViewDelegate, KolodaViewDataSource {

    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        return UIView()
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 2
    }
    
    
}

