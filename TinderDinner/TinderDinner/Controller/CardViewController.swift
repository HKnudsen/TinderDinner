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
        let textView = UILabel(frame: CGRect(x: 20, y: 200, width: 100, height: 50))
        textView.text = "Test"
        textView.textColor = .blue
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height))
        let view = UIImageView(image: UIImage(named: "ironman\(index + 1)"))
        view.frame = parentView.bounds
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        parentView.layer.cornerRadius = 20
        parentView.clipsToBounds = true
        parentView.autoresizesSubviews = true
        parentView.addSubview(view)
        parentView.addSubview(textView)
        
        
        //return parentView
        return parentView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(direction)
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 2
    }
    
    
}

