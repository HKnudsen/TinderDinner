//
//  DinnerYesListViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 22/02/2021.
//

import UIKit

class DinnerYesListViewController: UIViewController {
    
    var databaseManager = DatabaseManager.shared
    var firebaseManager = FirebaseManager.shared
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var restartLeaveBtn: UIButton!
    
    fileprivate let cellReusableId = "DinnerListTableViewCell"
    var dinnerList: [Dinner]?
    var dinnerNames: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate      = self
        listTableView.dataSource    = self
        let nib = UINib(nibName: "DinnerListTableViewCell", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: cellReusableId)
        
        if firebaseManager.isInOnlineSession {
            restartLeaveBtn.setTitle("Leave", for: .normal)
        }
        
        print(dinnerList)
        print("ListVC: \(databaseManager.wantedDinners?.count)")
        
        
    }
    
    @IBAction func didPressRestart(_ sender: UIButton) {
        print("DidPressRestart")
        let alertController = UIAlertController(title: "Are you sure?", message: "Restarting or leaving will delete the swipes you just did, and take you back to the main page", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        if firebaseManager.isInOnlineSession {
            NotificationCenter.default.post(Notification(name: Notification.Name("didExitGroupFromListVC")))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    func addDinnerToDinnerList(with dinner: Dinner) {
        if dinnerList == nil {
            dinnerList = [dinner]
        } else {
            dinnerList?.append(dinner)
        }
    }
}

extension DinnerYesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dinnerList = dinnerList else { return 0}
        return dinnerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: cellReusableId, for: indexPath) as! DinnerListTableViewCell
        if !firebaseManager.isInOnlineSession {
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
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SelectedDinnerViewController") as SelectedDinnerViewController
        vc.instantiatedFrom = "DinnerYesListViewController"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
