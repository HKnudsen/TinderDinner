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
    @IBOutlet weak var groupCodeLabel: UILabel!
    
    var databaseManager = DatabaseManager.shared
    var firebaseManager = FirebaseManager()
    
    var groupId: Int? {
        willSet {
            print(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isMultipleUsersSwith.isOn = false
        cardView.delegate = self
        cardView.dataSource = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        databaseManager.addNewIngredient(ingredient: "Dough")
        databaseManager.loadItems()
        databaseManager.removeDinnersWith(filter: databaseManager.unwantedIngredients!)
    }
    
    func addDinnerTest() {
        let dinner = Dinner(context: databaseManager.context)
        dinner.ingredients = ["Milk", "Dough"]
        dinner.name = "Second Best Dinner"
        dinner.origin = "Sweeden"
        
        do { try databaseManager.context.save() }
        catch let error { print(error) }
    }
    
    func joinPressed() {
        print("Join")
    }
    
    func createPressed() {
        firebaseManager.getUsedIds { (groupIds, error) in
            self.groupId = self.firebaseManager.checkForMachInIds(with: groupIds)
            DispatchQueue.main.async {
                if let groupId = self.groupId {
                    self.groupCodeLabel.text = "\(groupId)"
                }
                
            }
        }
        
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if sender.isOn {
            let alertController = UIAlertController(title: "Connect With Someone", message: "Do you want to create or join a room?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action) in
                self.joinPressed()
            }))
            alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
                self.createPressed()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.isMultipleUsersSwith.setOn(false, animated: true)
            }))
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
}


extension CardViewController: KolodaViewDelegate, KolodaViewDataSource {

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height))
        let view = UIImageView(image: UIImage(named: "ironman\(index + 1)"))
        
        let textView = UILabel(frame: CGRect(x: 20, y: parentView.frame.size.height - 70, width: 100, height: 50))
        textView.text = "Test"
        textView.textColor = .blue
        
        view.frame = parentView.bounds
        view.frame.size.height = parentView.frame.size.height - 100
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        parentView.layer.cornerRadius = 20
        parentView.backgroundColor = .white
        parentView.clipsToBounds = true
        parentView.autoresizesSubviews = true
        parentView.addSubview(view)
        parentView.addSubview(textView)
        
        //return parentView
        return parentView
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up]
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        // Save
        if direction == SwipeResultDirection.right {
            guard let items = databaseManager.items else {
                fatalError("No items found at databaseManager: 118 CardVC")
            }
            databaseManager.addToWantedDinner(with: items[index])
        // Dont save
        } else if direction == SwipeResultDirection.left {
            
        } else if direction == SwipeResultDirection.up {
            // TODO: End the swiping and go to dinner at index
            print("UP!")
        }
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 2
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        // Perform segue to results page
        performSegue(withIdentifier: "resultsPage", sender: self)
    }
    
    
}

