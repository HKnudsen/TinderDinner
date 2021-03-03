//
//  MultiUserSettingsViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 01/03/2021.
//

import UIKit

class MultiUserSettingsViewController: UIViewController {
    
    var settingsManager = SettingsManager.shared
    var databaseManager = DatabaseManager.shared
    var firebaseManager = FirebaseManager.shared

    @IBOutlet weak var numberOfCardsLabel: UILabel!
    @IBOutlet weak var numberOfCardsSlider: UISlider!
    @IBOutlet weak var allergensTableView: UITableView!
    
    fileprivate let reuseIdentifier = "FilterTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allergensTableView.dataSource   = self
        allergensTableView.delegate     = self
        
        numberOfCardsLabel.text = String(settingsManager.numberOfDesieredCards)
        numberOfCardsSlider.value = 20
        
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        allergensTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        numberOfCardsLabel.text = String(Int(sender.value))
        settingsManager.numberOfDesieredCards = Int(sender.value)
        firebaseManager.numberOfDesiredCards = Int(sender.value)
    }
    
    @IBAction func startSessionPressed(_ sender: UIButton) {
        databaseManager.filterWithMultipleAllergens()
        var dinners = [Dinner]()
        var dinnerIds = [Int]()
        for dinner in 0..<settingsManager.numberOfDesieredCards {
            print("elements: \(databaseManager.allItemsWithCurrentFiler)")
            for i in databaseManager.allItemsWithCurrentFiler! {
                print(i.name)
            }
            let randomElement = databaseManager.allItemsWithCurrentFiler?.randomElement()
            print("RANDOM ELEMENT: \(randomElement?.name)")
            let randomElementIndex = (databaseManager.allItemsWithCurrentFiler?.firstIndex(of: randomElement!))!
            databaseManager.allItemsWithCurrentFiler?.remove(at: randomElementIndex)
            dinnerIds.append(Int(randomElement!.uniqueID))
        }
        
        firebaseManager.startOnlineSession(withDinnersIds: dinnerIds)
        databaseManager.getDinnersWithMultipleIds(ids: dinnerIds)
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didStartOnlineSessionObserver"), object: nil)
        }
    }
    
    func createArrayForEachUser() {
        
    }
    
}

extension MultiUserSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseManager.allergensState!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FilterTableViewCell
        cell.label.text = databaseManager.allergensState?.allKeys[indexPath.row] as? String
        let allergenState = databaseManager.allergensState?.object(forKey: cell.label.text)
        
        if allergenState as! Int == 1 {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        databaseManager.editAllergenPlistData(allergen: cell.label.text!)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
}
