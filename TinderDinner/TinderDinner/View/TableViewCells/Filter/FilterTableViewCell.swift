//
//  FilterTableViewCell.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 25/02/2021.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
