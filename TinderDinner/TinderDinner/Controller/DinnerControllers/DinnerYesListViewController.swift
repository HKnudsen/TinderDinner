//
//  DinnerYesListViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 22/02/2021.
//

import UIKit

class DinnerYesListViewController: UIViewController {
    
    
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
    }
}

extension DinnerYesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: cellReusableId, for: indexPath) as! DinnerListTableViewCell
        cell.dinnerImage.image = #imageLiteral(resourceName: "ironman1")
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
