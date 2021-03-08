//
//  ViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 07/02/2021.
//

import UIKit
import CoreData
import Koloda
import Firebase

class CardViewController: UIViewController {

    @IBOutlet weak var cardView: KolodaView!
    @IBOutlet weak var isMultipleUsersSwith: UISwitch!
    @IBOutlet weak var groupCodeLabel: UILabel!
    
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var popupImageView: UIImageView!
    
    var databaseManager = DatabaseManager.shared
    var firebaseManager = FirebaseManager.shared
    var settingsManager = SettingsManager.shared
    var preloadManager = PreloadManager()
    
    var groupId: Int? {
        willSet {
            print(newValue)
            groupCodeLabel.text = "\(newValue!)"
        }
    }
    
    var hasRefreshedKolodaView: Bool = false
    
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onlineSessionStartedByHost),
                                               name: NSNotification.Name(rawValue: "didStartOnlineSessionObserver"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeBackToSingleUserState), name: NSNotification.Name("didExitGroupFromListVC"), object: nil)
    }
    
    
    override func loadView() {
        super.loadView()
        preloadManager.checkIfPreloaded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the imgView.
        isMultipleUsersSwith.isOn = false
        cardView.delegate = self
        cardView.dataSource = self
        tabBarItem.title = "Swipe"
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print("PATH: \(path)")
        
        
        
        
        
//        popupContainer.alpha = 0.0
//        popupContainer.layer.cornerRadius = 20
        popupImageView.layer.cornerRadius = 20
//        popupContainer.backgroundColor = .none
        
        //This has to be called first to check if some allergens has been selected
        databaseManager.loadAllergensPlistData()
        databaseManager.filterWithMultipleAllergens()
        databaseManager.appendCardsToKolodaWithAmount(number: settingsManager.numberOfDesieredCards)
        
        // THIS MIGHT HAVE TO BE UNCOMMENTED
//        cardView.resetCurrentCardIndex()

        
        print(databaseManager.itemsForCardView)
        print(UIDevice().type)
        
        setupObservers()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        if cardView.isRunOutOfCards {
            databaseManager.filterWithMultipleAllergens()
            cardView.resetCurrentCardIndex()
        }
        if firebaseManager.isInOnlineSession {
            self.tabBarController!.tabBar.items![1].isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if hasRefreshedKolodaView == false {
            hasRefreshedKolodaView = true
            DispatchQueue.main.async {
                self.cardView.reloadData()
            }
        }
    }
    
    @objc func onlineSessionStartedByHost() {
        self.tabBarController!.tabBar.items![1].isEnabled = false
        cardView.resetCurrentCardIndex()
    }
    
    fileprivate func prepareForOnlineSession(inputCode: String) {
        let waitingForHostAlertController = UIAlertController(title: "Waiting for host to start", message: "", preferredStyle: .alert)
        waitingForHostAlertController.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { (action) in
            self.leaveGroupPressed(groupCode: Int(inputCode)!)
        }))
        self.groupId = Int(inputCode)
        self.firebaseManager.activeGroupId = Int(inputCode)
        self.firebaseManager.isInOnlineSession = true
        self.firebaseManager.createUniqueUserId()
        self.firebaseManager.isGroupCreator = false
        self.tabBarController!.tabBar.items![1].isEnabled = false
        self.firebaseManager.initiateEventListenerFor(groupCode: Int(inputCode)!) { (document) in
            self.firebaseManager.getFirebaseObject(document: document) { (groupStructure) in
                print(groupStructure)
                waitingForHostAlertController.message = "Participants: \(groupStructure.participants)"
                if groupStructure.swipingSessionRunning == true {
                    self.startOnlineSession(groupStructure: groupStructure)
                    self.firebaseManager.detachEventListener()
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        self.present(waitingForHostAlertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Group Section
    
    func joinPressed() {
        let joinGroupController = UIAlertController(title: "Join", message: "Enter group code", preferredStyle: .alert)
        joinGroupController.addTextField()
        joinGroupController.textFields![0].delegate = self
        joinGroupController.textFields![0].smartInsertDeleteType = UITextSmartInsertDeleteType.no
        joinGroupController.textFields![0].keyboardType = .numberPad
        
        joinGroupController.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action) in
            if let inputCode = joinGroupController.textFields![0].text {
                Firestore.firestore().collection("Groups").document(inputCode).getDocument { (document, error) in
                    if let document = document {
                        if document.exists {
                            self.firebaseManager.getFirebaseObject(document: document) { (groupStructure) in
                                self.firebaseManager.addOneParticipant(to: inputCode)
                                self.prepareForOnlineSession(inputCode: inputCode)
                            }
                        } else {
                            print("Doesnt exist vc")
                        }
                    }
                }
            }
        }))
        
        joinGroupController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            self.isMultipleUsersSwith.setOn(false, animated: true)
        }))
        
        self.present(joinGroupController, animated: true, completion: nil)
    }
    
    func createPressed() {
        firebaseManager.getUsedIds { (groupIds, error) in
            self.groupId = self.firebaseManager.checkForMachInIds(with: groupIds)
            DispatchQueue.main.async {
                if let groupId = self.groupId {
                    self.groupCodeLabel.text = "\(groupId)"
                }
            }
            if let groupId = self.groupId {
                self.firebaseManager.activeGroupId = groupId
                let waitingForParticipantsController = UIAlertController(title: "\(groupId)", message: "Waiting for participants \n Number of participants: 1. Wait for everyone to join, and press start", preferredStyle: .alert)
                
                waitingForParticipantsController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    self.isMultipleUsersSwith.setOn(false, animated: true)
                    
                    self.firebaseManager.detachEventListener()
                }))
                
                waitingForParticipantsController.addAction(UIAlertAction(title: "Start", style: .default, handler: { (actuin) in
                    self.dismiss(animated: true) {
                        print("Starting online session")
                        self.moveToOnlineSessionSettings()
                    }
                }))
                
                self.present(waitingForParticipantsController, animated: true, completion: nil)
                self.firebaseManager.createGroup(with: groupId, numberOfDesiredCards: self.settingsManager.numberOfDesieredCards)
                self.firebaseManager.createUniqueUserId()
                self.firebaseManager.initiateEventListenerFor(groupCode: groupId) { (document) in
                    self.firebaseManager.getFirebaseObject(document: document) { (groupStructure) in
                        waitingForParticipantsController.message = "Waiting for participants \n Number of participants: \(groupStructure.participants). Wait for everyone to join, and press start"
                        print("Listener ran")
                    }
                }
            }
        }
    }
    
    func leaveGroupPressed(groupCode: Int) {
        firebaseManager.activeGroupId = nil
        firebaseManager.detachEventListener()
        firebaseManager.isInOnlineSession = false
        self.tabBarController!.tabBar.items![1].isEnabled = true
        isMultipleUsersSwith.setOn(false, animated: true)
        firebaseManager.removeOneFromParticipants(groupCode: groupCode)
        databaseManager.wantedDinnersId = nil
    }
    
    func startOnlineSession(groupStructure: GroupStructure) {
        databaseManager.getDinnersWithMultipleIds(ids: groupStructure.dinnerIdsForCardView)
        cardView.reloadData()
        
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if sender.isOn {
            let alertController = UIAlertController(title: "Connect With Someone", message: "Do you want to create or join a room?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action) in
                self.joinPressed()
            }))
            alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
                self.createPressed()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.isMultipleUsersSwith.setOn(false, animated: true)
            }))
            present(alertController, animated: true, completion: nil)
        } else {
            changeBackToSingleUserState()
        }
    }
    
    @objc func changeBackToSingleUserState() {
        isMultipleUsersSwith.setOn(false, animated: true)
        tabBarController!.tabBar.items![1].isEnabled = true
        firebaseManager.isInOnlineSession = false
        firebaseManager.activeGroupId = nil
        groupCodeLabel.text = nil
        groupCodeLabel.isHidden = true
        firebaseManager.leftSwipedDinnerIds = []
        databaseManager.wantedDinnersId = nil
    }
    
    // Changes rootVC to Tab Bar for online session settings
    func moveToOnlineSessionSettings() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onlineSessionSettingsController = storyboard.instantiateViewController(identifier: "onlineSessionSettings")
        modalPresentationStyle = .fullScreen
        self.present(onlineSessionSettingsController, animated: true) {
            
        }
    }
}



// MARK: - Koloda Section

extension CardViewController: KolodaViewDelegate, KolodaViewDataSource {

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let allDinners = databaseManager.itemsForCardView
        let dinner = databaseManager.itemsForCardView![index]

        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height))
    
        let imgView = UIImageView(image: UIImage(data: dinner.image!))
        
        let bottomView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 20
            return view
        }()
        
        let stackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.backgroundColor = .cyan
            view.layer.cornerRadius = 20
            return view
        }()
        
        let leftBottomView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 20
            view.backgroundColor = .blue
            return view
        }()
        
        let rightBottomView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 20
            view.backgroundColor = .red
            return view
        }()
        
        let leftList: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.distribution = .fillEqually
            view.backgroundColor = .brown
            return view
        }()
        
        let rightList: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.distribution = .fillEqually
            return view
        }()
        
        parentView.addSubview(imgView)
        parentView.addSubview(bottomView)
        bottomView.addSubview(stackView)
        stackView.addArrangedSubview(leftBottomView)
        stackView.addArrangedSubview(rightBottomView)
        leftBottomView.addSubview(leftList)
        rightBottomView.addSubview(rightList)
        
        // This enables autolayout for imgView
        imgView.translatesAutoresizingMaskIntoConstraints = false

        imgView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 10).isActive = true
        imgView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10).isActive = true
        imgView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10).isActive = true
        imgView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: parentView.frame.size.height * 0.66).isActive = true
        
        bottomView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10).isActive = true
        bottomView.topAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true
        
        stackView.fillInParent(parent: bottomView)
        leftList.fillInParent(parent: leftBottomView)
        rightList.fillInParent(parent: rightBottomView)
    
        parentView.layer.cornerRadius = 20
        parentView.autoresizesSubviews = true
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        
        if let allItems = allDinners {
            print("All items count\(allItems.count)")
            for item in allItems {
                print("ITEM NAME\(item.name)")
            }
            print("DONE!!")
            for (step, item) in allItems[index].howToMake!.enumerated() {

                let stepText: UITextView = {
                    let view = UITextView()
                    view.text = "\(step): " + item
                    view.textAlignment = .center
                    return view
                }()
                rightList.addArrangedSubview(stepText)
            }
            
            for ingredient in allItems[index].ingredients! {
                let ingredientText: UITextView = {
                    let view = UITextView()
                    view.text = "\(ingredient)"
                    view.textAlignment = .center
                    return view
                }()
                leftList.addArrangedSubview(ingredientText)
            }
            
            let name: UITextView = {
                let view = UITextView()
                view.text = "\(allItems[index].name)"
                return view
            }()
            leftList.addArrangedSubview(name)
        }
        return parentView
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up]
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard let items = databaseManager.itemsForCardView else {
            fatalError("No items found at databaseManager CardVC")
        }
        
        if isMultipleUsersSwith.isOn == true {
            // Multiple Users
            switch direction {
            case SwipeResultDirection.right:
                print("Swipe right multiuser")
                firebaseManager.saveDinnerIdToLocalStage(with: Int(items[index].uniqueID))
            case SwipeResultDirection.left:
                print("Swipe left multiuser")
            case SwipeResultDirection.up:
                print("Swipe up multiuser")
            default:
                fatalError("Error in didSwipeCardAt")
            }
        } else {
            // Single User
            switch direction {
            case SwipeResultDirection.right:
                databaseManager.addToWantedDinner(with: Int(items[index].uniqueID))
                print(databaseManager.wantedDinnersId?.count)
            case SwipeResultDirection.left:
                print("Swipe left singleuser")
            case SwipeResultDirection.up:
                if let itemName = items[index].name {
                    databaseManager.addDinnerToFavourites(with: itemName)
                }
                
            default:
                fatalError("Error in didSwipeCardAt")
            }
        }
    }
    // This has du be changed after testing ????
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        if isMultipleUsersSwith.isOn == false {
            databaseManager.loadAllergensPlistData()
            databaseManager.filterWithMultipleAllergens()
            if databaseManager.appendCalled == 0 {
                databaseManager.appendCardsToKolodaWithAmount(number: settingsManager.numberOfDesieredCards)

            }
            print("DATABASE COUNT\(databaseManager.itemsForCardView!.count)")
            print("ITEMSFORCARDVIEW: ")
            for item in databaseManager.itemsForCardView! {
                print("ITEM CV: \(item.name)")
            }
            return databaseManager.itemsForCardView!.count
        } else {
            print("DATABASE ITEMS COUNT: \(databaseManager.itemsForCardView!.count)")
            return databaseManager.itemsForCardView!.count
        }

    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        if isMultipleUsersSwith.isOn == true {
            firebaseManager.addDinnerIdsToFirebase(with: firebaseManager.localUserYesSwiped, for: groupId!, at: firebaseManager.uniqueUserId!)

            firebaseManager.markThisUserAsReady()

            firebaseManager.initiateEventListenerFor(groupCode: firebaseManager.activeGroupId!) { (document) in

                self.firebaseManager.getFirebaseObject(document: document) { (groupStructure) in

                    if groupStructure.numberOfUsersReady == groupStructure.participants {
                        
                        let leftSwipeCount = self.firebaseManager.countYesSwipes(yesSwipedDinnerIdArrays: groupStructure.collectionOfAcceptedDinnerList)
                        var votedDinnerIds = self.firebaseManager.getDinnersWithMostVotes(voteCount: leftSwipeCount, participants: groupStructure.participants)
                        var dinners = self.databaseManager.getDinnersWithMultipleIds(Ids: votedDinnerIds)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "DinnerYesListViewController") as DinnerYesListViewController
                        vc.modalPresentationStyle = .fullScreen
                        vc.dinnerList = dinners
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "DinnerYesListViewController") as DinnerYesListViewController
            vc.modalPresentationStyle = .fullScreen
            vc.dinnerList = databaseManager.getDinnersWithMultipleIds(Ids: databaseManager.wantedDinnersId!)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        print(finishPercentage, direction)
        if finishPercentage > 10  && direction == .right {
            popupContainer.alpha = finishPercentage / 95
            popupImageView.image = .add

        } else if finishPercentage > 10 && direction == .left {
            popupContainer.alpha = finishPercentage / 95
            popupImageView.image = .remove

        } else if finishPercentage > 10 && direction == .up {
            popupContainer.alpha = finishPercentage / 95
            popupImageView.image = .strokedCheckmark
        }
    }
    
    func kolodaPanFinished(_ koloda: KolodaView, card: DraggableCardView) {
        popupContainer.alpha = 0.0
    }
    
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return .init(0.6)
    }
}



// MARK:- UITextField Section
// UITextFieldDelegate for UIAlertController

extension CardViewController: UITextFieldDelegate {
    // Limits length to 5
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 5
    }
}




