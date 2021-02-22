//
//  FirebaseManager.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 12/02/2021.
//

import Foundation
import Firebase

struct FirebaseManager {
    
    var activeEventListener: ListenerRegistration?
    
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
        let newGroup = GroupStructure(participants: 1, acceptedDinners: ["none"], swipingSessionRunning: false, removedIngredients: [String]())
        do { try dbRef.setData(from: newGroup) }
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
    
    mutating func initiateEventListenerFor(groupCode: Int, completion: @escaping (DocumentSnapshot) -> Void) {
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
    
    mutating func removeEventListener() {
        self.activeEventListener?.remove()
        self.activeEventListener = nil
    }
    
    func appendToFirebase(with dinnerName: String) {
        
    }
    
    
}

