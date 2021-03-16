//
//  FilterSettingsViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 08/02/2021.
//

import UIKit
import CoreData

class FilterSettingsViewController: UIViewController {

    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let reuseIdentifier = "FilterTableViewCell"
    
    let databaseManager = DatabaseManager.shared
    
    // Used to search for allergens in table
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate      = self
        tableView.dataSource    = self
        let nib = UINib(nibName: K.cells.filterTBCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        

        
    }
}

extension FilterSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(databaseManager.allergensState!.count)
        return databaseManager.allergensState!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(databaseManager.allergensState!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FilterTableViewCell
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
