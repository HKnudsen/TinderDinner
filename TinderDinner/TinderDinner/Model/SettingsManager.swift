//
//  SettingsManager.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 08/02/2021.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    let settingOptions = ["Filter", "Favourites", "Settings", "About"]
    var numberOfDesieredCards: Int = 5
}
