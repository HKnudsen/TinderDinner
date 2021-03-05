//
//  GroupStructure.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 21/02/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct GroupStructure: Codable {
    var participants: Int
    var swipingSessionRunning: Bool
    var numberOfCards: Int
    var dinnerIdsForCardView: [Int]
    var numberOfUsersReady: Int
//    var collectionOfAcceptedDinnerList: [[String: [Int]]]
    var collectionOfAcceptedDinnerList: [String: [Int]]
    
    enum CodingKeys: String, CodingKey {
        case participants
        case swipingSessionRunning
        case numberOfCards
        case dinnerIdsForCardView
        case numberOfUsersReady
        case collectionOfAcceptedDinnerList
    }
}

struct acceptedDinnerList: Codable {
    var acceptedDinners: [Int]
}

