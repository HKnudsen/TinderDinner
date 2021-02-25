//
//  SelectedDinnerViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 18/02/2021.
//

import UIKit

class SelectedDinnerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exitButton: UIButton!
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let padding: CGFloat = 16
    var dinner: Dinner?
    var instantiatedFrom: String?
    
    var headerView: HeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        
        setupCollectionViewLayout()
        setupCollectionView()
        
        print(dinner?.name)
        exitButton.imageView?.image = .remove
        let image = UIImage.remove
        exitButton.setImage(image, for: .normal)
        exitButton.setTitle("", for: .normal)
        
        print(instantiatedFrom)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    
    
    
    @IBAction func exitPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: instantiatedFrom ?? "FavouritesViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Layout & Animation Section
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor                  = .blue
        collectionView.contentInsetAdjustmentBehavior   = .never
        collectionView.collectionViewLayout             = StretchyHeaderLayout()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func setupCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Stops animation to prevent system from crashing when trying to start an active animation on app re-open
        headerView?.animator.stopAnimation(true)
        headerView?.animator.finishAnimation(at: .current)
    }
}



// MARK: - UICollectionView
extension SelectedDinnerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * padding, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderView
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if UIDevice().type.rawValue == "iPad Pro 4 12.9\"" {
            
        }
        
        if UIDevice().type == Model.iPadPro4_12_9 || UIDevice().type == Model.iPadPro3_12_9 || UIDevice().type == Model.iPadPro2_12_9 {
            return .init(width: view.frame.width, height: 730)
        }
        
        return .init(width: view.frame.width, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > 0 {
            headerView?.animator.fractionComplete = 0
            return
        }
        headerView?.animator.fractionComplete = abs(contentOffsetY / 100)
    }
}
