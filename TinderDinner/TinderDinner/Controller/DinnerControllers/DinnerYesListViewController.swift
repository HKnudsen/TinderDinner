//
//  DinnerYesListViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 22/02/2021.
//

import UIKit

class DinnerYesListViewController: UIViewController {
    
    var databaseManager = DatabaseManager.shared
    
    @IBOutlet weak var listTableView: UITableView!
    
    fileprivate let cellReusableId = "DinnerListTableViewCell"
    var dinnerList: [Dinner]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate      = self
        listTableView.dataSource    = self
        let nib = UINib(nibName: "DinnerListTableViewCell", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: cellReusableId)
        print(dinnerList)
        print("ListVC: \(databaseManager.wantedDinners?.count)")
    }
}

extension DinnerYesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wantedDinners = databaseManager.wantedDinners {
            return wantedDinners.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: cellReusableId, for: indexPath) as! DinnerListTableViewCell
        if let wantedDinners = databaseManager.wantedDinners {
            guard let data = wantedDinners[indexPath.row].image else { fatalError("Error loading png data from CoreData") }
            let image = UIImage(data: data)
            cell.dinnerImage.image = image
        } else {
            cell.dinnerImage.image = #imageLiteral(resourceName: "ironman2")
            print("Error ja")
        }
        
        cell.dinnerLabel.text = "Test text"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SelectedDinnerViewController") as SelectedDinnerViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
