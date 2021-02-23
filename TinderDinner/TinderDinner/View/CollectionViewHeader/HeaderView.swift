//
//  HeaderView.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 21/02/2021.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    let imageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "ironman2"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var visualEffectView = UIVisualEffectView(effect: nil)
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        addSubview(imageView)
        imageView.fillInParent(parent: self)
        
        // blur
        setupVisualEffectBlur()
    }
    
    fileprivate func setupVisualEffectBlur() {
        self.addSubview(visualEffectView)
        animator.addAnimations {
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
        }
        animator.fractionComplete = 0
        visualEffectView.fillInParent(parent: self)
        animator.pausesOnCompletion = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init coder has not been implemented")
    }
}
