//
//  SwipeSettingsViewController.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 28/02/2021.
//

import UIKit

class SwipeSettingsViewController: UIViewController {

    @IBOutlet weak var numberOfCardsLabel: UILabel!
    @IBOutlet weak var numberOfCardsSlider: UISlider!
    
    var settingsManager = SettingsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        numberOfCardsSlider.value = 5
        numberOfCardsLabel.text = "5"
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        numberOfCardsLabel.text = String(Int(sender.value))
        
        settingsManager.numberOfDesieredCards = Int(sender.value)
    }
    
}
 
