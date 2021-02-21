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
    var acceptedDinners: [String]
    var swipingSessionRunning: Bool
    var removedIngredients: [String]
    
    enum CodingKeys: String, CodingKey {
        case participants
        case acceptedDinners
        case swipingSessionRunning
        case removedIngredients
    }
}

