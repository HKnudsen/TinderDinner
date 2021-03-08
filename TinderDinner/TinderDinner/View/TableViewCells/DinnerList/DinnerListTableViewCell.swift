//
//  DinnerListTableViewCell.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 22/02/2021.
//

import UIKit

class DinnerListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dinnerImage: UIImageView!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var countLeftSwipe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dinnerImage.contentMode     = .scaleAspectFill
        dinnerLabel.textColor       = .white
        countLeftSwipe.isHidden     = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
