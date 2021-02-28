//
//  SettingsViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 08/02/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settingsManager = SettingsManager()
    var databaseManager = DatabaseManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tabBarItem.title = "Settings"
    }
    
    fileprivate func setupTableView() {
        tableView.delegate      = self
        tableView.dataSource    = self
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingsTBCell")
    }
}


// MARK: - TableView Section

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsManager.settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell().identifier, for: indexPath) as! SettingsTableViewCell
        cell.txtLabel.text = settingsManager.settingOptions[indexPath.row]
        cell.backgroundColor = .darkGray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.frame.height / CGFloat(settingsManager.settingOptions.count))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "filterSettings", sender: self)
        case 1:
            performSegue(withIdentifier: "goToFavourites", sender: self)
        case 2:
            performSegue(withIdentifier: "goToSettings", sender: self)
        default:
            
            print("clicked on tbv")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
