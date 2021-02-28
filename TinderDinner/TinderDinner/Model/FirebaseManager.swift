//
//  FirebaseManager.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 12/02/2021.
//

import Foundation
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    var activeEventListener: ListenerRegistration?
    var activeGroupId: Int?
    var isGroupCreator: Bool = false
    var isInOnlineSession: Bool = false
    var leftSwipedDinnerNames = [String]()
    
    
    
    // MARK: - ID Section
    func getUsedIds(completion: @escaping ([Int], Error?) -> Void) {
        let dbRef = Firestore.firestore().collection("Groups")
        var documentIdArray = [Int]()
        
        dbRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error Firebasemanager \(error)")
                completion(documentIdArray, error)
            } else {
                for document in snapshot!.documents {
                    documentIdArray.append(Int(document.documentID)!)
                }
                completion(documentIdArray, nil)
            }
        }
    }
    
    // Call this after getUsedIds to get a unique id that's not in documentIdArray
    func checkForMachInIds(with groupIds: [Int]) -> Int {
        var randomCode = Int.random(in: 1...10000)
        while groupIds.contains(randomCode) {
            randomCode = Int.random(in: 1...10000)
        }
        return randomCode
    }
    
    // Removes the used group ID after online session
    func collectGarbageId(groupId: Int) {
        let dbRef = Firestore.firestore().collection("Groups").document("\(groupId)")
        dbRef.delete()
    }

    

    //MARK: - Group Edit Section
    
    func createGroup(with groupId: Int) {
        let dbRef = Firestore.firestore().collection("Groups").document("\(groupId)")
        let newGroup = GroupStructure(participants: 1, acceptedDinners: [String](), swipingSessionRunning: false, removedIngredients: [String]())
        do { try dbRef.setData(from: newGroup); self.isGroupCreator = true }
        catch let error { print(error) }
    }
    
    // Call this function to transform a DocumentSnapshot to a Swift compatible struct
    func getFirebaseObject(document: DocumentSnapshot, completion: @escaping(GroupStructure) -> Void) {
        let result = Result {
            try document.data(as: GroupStructure.self)
        }
        
        switch result {
        case .success(let response):
            if let response = response {
                completion(response)
            } else {
                print("Document Doesnt exist")
            }
        case .failure(let error):
            print(error)
        }
    }
    
    // Works for now. Might not work with multiple user input at the same time.
    func appendToFirebase(with dinnerName: String, groupId: Int) {
        let dbRef = Firestore.firestore().collection("Groups").document("\(groupId)")
        dbRef.getDocument { (document, error) in
            if let document = document {
                self.getFirebaseObject(document: document) { (groupStructure) in
                    var groupData = groupStructure
                    groupData.acceptedDinners.append(dinnerName)
                    do { try dbRef.setData(from: groupData) }
                    catch let error { print("Error transforming data to firebase: \(error)") }
                }
            }

        }
    }
    
    func addDinnerNameToFirebase(with dinnerName: String, groupId: Int) {
        let dbRef = Firestore.firestore().collection("Groups").document("\(groupId)")
        dbRef.updateData([
            "acceptedDinners": FieldValue.arrayUnion([dinnerName])
        ])
    }
    
    // Gets the data from firebase when session is done
    func retrieveLeftSwipedDinnerNames(completion: @escaping (GroupStructure) -> Void) {
        let dbRef = Firestore.firestore().collection("Groups").document("\(activeGroupId!)")
        dbRef.getDocument { (document, error) in
            if let document = document {
                self.getFirebaseObject(document: document) { (groupStructure) in
                    self.leftSwipedDinnerNames = groupStructure.acceptedDinners
                    completion(groupStructure)
                }
            }
        }
    }

    
    
    // MARK: - Event Listener Section
    
    func initiateEventListenerFor(groupCode: Int, completion: @escaping (DocumentSnapshot) -> Void) {
         let listener = Firestore.firestore().collection("Groups").document("\(groupCode)").addSnapshotListener { (document, error) in
            if let document = document {
                completion(document)
            } else {
                if let error = error {
                    print("Error getting snapshot from eventlistener: Firebasemanager: \(error)")
                }
            }
        }
        self.activeEventListener = listener
    }
    
    func detachEventListener() {
        self.activeEventListener?.remove()
        self.activeEventListener = nil
    }
}

