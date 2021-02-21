//
//  ViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 07/02/2021.
//

import UIKit
import CoreData
import Koloda
import Firebase

// Figure out a way to merge data from swiping to avoid overwrites when using multiple users. ArrayUnion doesnt work.

class CardViewController: UIViewController {

    @IBOutlet weak var cardView: KolodaView!
    @IBOutlet weak var isMultipleUsersSwith: UISwitch!
    @IBOutlet weak var groupCodeLabel: UILabel!
    
    var databaseManager = DatabaseManager.shared
    var firebaseManager = FirebaseManager()
    
    var groupId: Int? {
        willSet {
            print(newValue)
            groupCodeLabel.text = "\(newValue)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the imgView.
        isMultipleUsersSwith.isOn = false
        cardView.delegate = self
        cardView.dataSource = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        databaseManager.addNewIngredient(ingredient: "Dough")
        databaseManager.loadItems()
//        databaseManager.removeDinnersWith(filter: databaseManager.unwantedIngredients!)
        print(databaseManager.items)

    }
    
    func addDinnerTest() {
        let dinner = Dinner(context: databaseManager.context)
        dinner.ingredients = ["Milk", "Dough"]
        dinner.name = "Second Best Dinner"
        dinner.origin = "Sweeden"
        dinner.howToMake = ["Mix milk and dough", "Make make", "Done!"]
        
        do { try databaseManager.context.save() }
        catch let error { print(error) }
    }
    
    func joinPressed() {
        let joinGroupController = UIAlertController(title: "Join", message: "Enter group code", preferredStyle: .alert)
        joinGroupController.addTextField()
        joinGroupController.textFields![0].delegate = self
        joinGroupController.textFields![0].smartInsertDeleteType = UITextSmartInsertDeleteType.no
        joinGroupController.textFields![0].keyboardType = .numberPad
        
        joinGroupController.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action) in
            if let inputCode = joinGroupController.textFields![0].text {
                Firestore.firestore().collection("Groups").document(inputCode).getDocument { (document, error) in
                    if let document = document {
                        if document.exists {
                            self.firebaseManager.getFirebaseObject(document: document) { (groupStructure) in
                                self.groupId = Int(inputCode)
                                self.firebaseManager.initiateEventListenerFor(groupCode: Int(inputCode)!) { (document) in
                                    self.firebaseManager.getFirebaseObject(document: document) { (groupStructure) in
                                        print(groupStructure)
                                    }
                                }
                            }
                        } else {
                            print("Doesnt exist vc")
                        }

                    }
                }
            }
            
        }))
        
        joinGroupController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            self.isMultipleUsersSwith.setOn(false, animated: true)
        }))
        
        self.present(joinGroupController, animated: true, completion: nil)
    }
    
    func createPressed() {
        firebaseManager.getUsedIds { (groupIds, error) in
            self.groupId = self.firebaseManager.checkForMachInIds(with: groupIds)
            DispatchQueue.main.async {
                if let groupId = self.groupId {
                    self.groupCodeLabel.text = "\(groupId)"
                }
            }
            if let groupId = self.groupId {
                
                let waitingForParticipantsController = UIAlertController(title: "\(groupId)", message: "Waiting for participants \n Number of participants: 1", preferredStyle: .alert)
                waitingForParticipantsController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    self.isMultipleUsersSwith.setOn(false, animated: true)
                    
                    self.firebaseManager.removeEventListener()
                    
                }))
                waitingForParticipantsController.addAction(UIAlertAction(title: "Start", style: .default, handler: { (actuin) in
                    self.dismiss(animated: true) {
                        print("Starting online session")
                        self.firebaseManager.removeEventListener()
                    }
                }))
                
                self.present(waitingForParticipantsController, animated: true, completion: nil)
                self.firebaseManager.createGroup(with: groupId)
                
                self.firebaseManager.initiateEventListenerFor(groupCode: groupId) { (document) in
                    self.firebaseManager.getFirebaseObject(document: document) { (groupStructure) in
                        waitingForParticipantsController.message = "Waiting for participants \n Number of participants: \(groupStructure.participants)"
                        print("Listener ran")
                    }
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
    let testIngredients = ["First", "Second", "Third", "Fourth", "Last"]
}




// MARK: - Koloda Section

extension CardViewController: KolodaViewDelegate, KolodaViewDataSource {

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height))
        let imgView = UIImageView(image: UIImage(named: "ironman\(index + 1)"))
        
        let bottomView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 20
            return view
        }()
        
        let stackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.backgroundColor = .cyan
            view.layer.cornerRadius = 20
            return view
        }()
        
        let leftBottomView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 20
            view.backgroundColor = .blue
            return view
        }()
        
        let rightBottomView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 20
            view.backgroundColor = .red
            return view
        }()
        
        let leftList: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.distribution = .fillEqually
            view.backgroundColor = .brown
            return view
        }()
        
        let rightList: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.distribution = .fillEqually
            return view
        }()
        
        parentView.addSubview(imgView)
        parentView.addSubview(bottomView)
        bottomView.addSubview(stackView)
        stackView.addArrangedSubview(leftBottomView)
        stackView.addArrangedSubview(rightBottomView)
        leftBottomView.addSubview(leftList)
        rightBottomView.addSubview(rightList)
        
        
        // This enables autolayout for imgView
        imgView.translatesAutoresizingMaskIntoConstraints = false

        imgView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 10).isActive = true
        imgView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10).isActive = true
        imgView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10).isActive = true
        imgView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: parentView.frame.size.height * 0.66).isActive = true
        
        bottomView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10).isActive = true
        bottomView.topAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true
        
        stackView.fillInParent(parent: bottomView)
        leftList.fillInParent(parent: leftBottomView)
        rightList.fillInParent(parent: rightBottomView)
    
        parentView.layer.cornerRadius = 20
        parentView.autoresizesSubviews = true
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        
        databaseManager.loadItems()
        
        if let items = databaseManager.items {
            for (k, item) in items.enumerated() {
                if let howToMake = item.howToMake {
                    for (j, step) in howToMake.enumerated() {
                        let ingredientText: UITextView = {
                            let view = UITextView()
                            view.text = "\(j)" + ": " + step
                            view.textAlignment = .center
                            return view
                        }()
                        rightList.addArrangedSubview(ingredientText)
                    }
                }
            }
        }

        for item in testIngredients {
            let ingredientText: UITextView = {
                let view = UITextView()
                view.text = item
                view.textColor = .green
                view.textAlignment = .center
                return view
            }()
        
            leftList.addArrangedSubview(ingredientText)
    
        }
        

        
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
            //databaseManager.addToWantedDinner(with: items[index])
        // Dont save
        } else if direction == SwipeResultDirection.left {
            
        } else if direction == SwipeResultDirection.up {
            // TODO: End the swiping and go to dinner at index
            print("UP!")
        }
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return databaseManager.items?.count ?? 2
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        // Perform segue to results page
        performSegue(withIdentifier: "resultsPage", sender: self)
    }
}



// MARK:- UITextField Section
// UITextFieldDelegate for UIAlertController

extension CardViewController: UITextFieldDelegate {
    // Limits length to 5
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 5
    }
}




