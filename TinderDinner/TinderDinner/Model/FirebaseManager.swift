//
//  FirebaseManager.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 12/02/2021.
//

import Foundation
import Firebase

struct FirebaseManager {
    
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
}

