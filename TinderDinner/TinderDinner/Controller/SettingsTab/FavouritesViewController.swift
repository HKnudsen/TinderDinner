//
//  FavouritesViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 23/02/2021.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    var databaseManager = DatabaseManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource    = self
        tableView.delegate      = self

        // Do any additional setup after loading the view.
    }
}


extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SelectedDinnerViewController") as SelectedDinnerViewController
        vc.modalPresentationStyle = .fullScreen
        vc.instantiatedFrom = "FavouritesViewController"
        self.present(vc, animated: true, completion: nil)
    }
}
