//
//  FavouritesViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 23/02/2021.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    var databaseManager = DatabaseManager.shared
    var dinners: [Dinner]?
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFavoriteDinners()
        setupTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteDinners()
        tableView.reloadData()
    }
    
    fileprivate func getFavoriteDinners() {
        let favoriteDinnerIds = UserDefaults.standard.array(forKey: K.UserDefaultString.favorites)
        
        if favoriteDinnerIds == nil {
            
        } else {
            let favoriteDinners: [Dinner] = databaseManager.getDinnersWithMultipleIds(Ids: favoriteDinnerIds as! [Int])
            self.dinners = favoriteDinners
        }
        
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource    = self
        tableView.delegate      = self
        let nib = UINib(nibName: K.cells.DinnerListTBCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.cells.DinnerListTBCell)
    }
}


extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dinners = dinners {
            if dinners.isEmpty {
                return 1
            } else {
                return dinners.count
            }
            
        } else {
            return 1
        }
//        return dinners?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dinners = dinners {
            if !dinners.isEmpty {
                guard let data = dinners[indexPath.row].image else { fatalError("Error image favorites") }
                let image = UIImage(data: data)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.DinnerListTBCell, for: indexPath) as! DinnerListTableViewCell
                cell.dinnerImage.image = image
                cell.dinnerLabel.text = dinners[indexPath.row].name
                
                return cell
            } else {
                let cell = UITableViewCell()
                cell.backgroundColor = .cyan
                cell.textLabel?.text = "No dinners added to favorites"
                cell.textLabel?.textAlignment = .center
                return cell
            }

        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .cyan
            cell.textLabel?.text = "No dinners added to favorites"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dinners = dinners {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: K.viewControllers.selectedDinnerVC) as SelectedDinnerViewController
            vc.modalPresentationStyle = .fullScreen
            vc.dinner = dinners[indexPath.row]
            vc.instantiatedFrom = K.viewControllers.favoritesVC
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let dinners = dinners {
            if editingStyle == .delete {
                let alertController = UIAlertController(title: "Are you sure?", message: K.messageStrings.deleteRowFromFavorites, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                    self.dinners?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    var favoriteDinnerIds = UserDefaults.standard.array(forKey: K.UserDefaultString.favorites)
                    favoriteDinnerIds?.remove(at: indexPath.row)
                    UserDefaults.standard.setValue(favoriteDinnerIds, forKey: K.UserDefaultString.favorites)
                    if favoriteDinnerIds!.isEmpty {
                        tableView.reloadData()
                    }
                }))
                alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
                
            }
        }
    }
}
