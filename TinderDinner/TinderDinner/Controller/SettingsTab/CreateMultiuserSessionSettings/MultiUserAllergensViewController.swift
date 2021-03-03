//
//  MultiUserAllergensViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 01/03/2021.
//

import UIKit

class MultiUserAllergensViewController: UIViewController {
    
    var databaseManager = DatabaseManager.shared

    @IBOutlet weak var allergensTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allergensTableView.delegate     = self
        allergensTableView.dataSource   = self
    }
}

extension MultiUserAllergensViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseManager.allergensState!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
