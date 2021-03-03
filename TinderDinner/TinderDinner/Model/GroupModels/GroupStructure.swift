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
    var acceptedDinnerList: [Int]
    var swipingSessionRunning: Bool
    var numberOfCards: Int
    var dinnerIdsForCardView: [Int]
    var numberOfUsersReady: Int
    
    enum CodingKeys: String, CodingKey {
        case participants
        case acceptedDinnerList
        case swipingSessionRunning
        case numberOfCards
        case dinnerIdsForCardView
        case numberOfUsersReady
    }
}

struct acceptedDinnerList: Codable {
    var acceptedDinners: [Int]
}

