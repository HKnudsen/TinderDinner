//
//  SelectedDinnerViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 18/02/2021.
//

import UIKit

class SelectedDinnerViewController: UIViewController {
    
    @IBOutlet weak var selectedDinnerCollectionView: UICollectionView!
    @IBOutlet weak var exitButton: UIButton!
    
    fileprivate let cellId = "DinnerInfoCell"
    fileprivate let headerId = "headerId"
    fileprivate let padding: CGFloat = 16
    var dinner: Dinner?
    var instantiatedFrom: String?
    
    var headerView: HeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDinnerCollectionView.delegate     = self
        selectedDinnerCollectionView.dataSource   = self
        
        
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
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: instantiatedFrom ?? "FavouritesViewController")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        // LOL
    }
    
    
    
    
    // MARK: - Layout & Animation Section
    fileprivate func setupCollectionView() {
        selectedDinnerCollectionView.backgroundColor                  = .blue
        selectedDinnerCollectionView.contentInsetAdjustmentBehavior   = .never
        selectedDinnerCollectionView.collectionViewLayout             = StretchyHeaderLayout()
        let nib = UINib(nibName: "DinnerInfoCell", bundle: nil)
        selectedDinnerCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        selectedDinnerCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func setupCollectionViewLayout() {
        if let layout = selectedDinnerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowsWithItemsCount: Int = (dinner?.howToMake!.count)! + (dinner?.ingredients!.count)!
//        return .init(width: view.frame.width - 2 * padding, height: CGFloat((rowsWithItemsCount * 200) + 20))
        return .init(width: view.frame.width - 2 * padding, height: CGFloat(500))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderView
        
        headerView?.imageView.image = UIImage(data: (dinner?.image)!)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectedDinnerCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DinnerInfoCell
        cell.setupUI(data: dinner!)
        return cell
        
//        let parentView = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height))
//
//        // Dinner Name Title
//        let titleView: UIView = {
//            let view = UIView()
//            view.translatesAutoresizingMaskIntoConstraints = false
//            return view
//        }()
//
//        let titleTextView: UITextView = {
//            let titleText = UITextView()
//            titleText.translatesAutoresizingMaskIntoConstraints = true
//            titleText.textAlignment = .center
//            return titleText
//        }()
//
//        titleView.addSubview(titleTextView)
//        parentView.addSubview(titleView)
//
//
//
//        return parentView
    }
}
