//
//  K.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 15/03/2021.
//

import Foundation

struct K {
    
    struct UserDefaultString {
        static let favorites: String = "favorites"
    }
    
    struct viewControllers {
        static let favoritesVC: String = "FavouritesViewController"
        static let selectedDinnerVC: String = "SelectedDinnerViewController"
    }
    
    struct cells {
        static let DinnerListTBCell: String = "DinnerListTableViewCell"
        static let filterTBCell: String = "FilterTableViewCell"
        static let settingsTBCell: String = "SettingsTableViewCell"
    }
    
    struct messageStrings {
        static let deleteRowFromFavorites: String = "Deleting will remove this dinner from your favorites"
    }
}
