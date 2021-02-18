//
//  SelectedDinnerViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 18/02/2021.
//

import UIKit

class SelectedDinnerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
    }
    
}

extension SelectedDinnerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            print("0")
            return UICollectionViewCell()
        case 1:
            print(1)
            return UICollectionViewCell()
        case 2:
            print(2)
            return UICollectionViewCell()
        default:
            fatalError("Error in cell for item at")
        }
    }
    
    
}
