//
//  ViewExtenstion.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 20/02/2021.
//

import UIKit

extension UIView {
    func fillInParent(parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
    }
    
    
    
}
