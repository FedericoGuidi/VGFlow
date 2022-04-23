//
//  SocialContactCollectionViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 23/04/22.
//

import UIKit

class SocialContactCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SocialContact"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    
    func configure(with social: Social) {
        infoLabel.text = social.value
        
        var backgroundConfiguration = UIBackgroundConfiguration.clear()
        backgroundConfiguration.cornerRadius = 25
        
        switch social.type {
        case .nintendoSwitch:
            imageView.image = UIImage(systemName: "gamecontroller.fill")
            backgroundConfiguration.backgroundColor = .systemRed
        case .xbox:
            imageView.image = UIImage(systemName: "logo.xbox")
            backgroundConfiguration.backgroundColor = .systemGreen
        case .playstation:
            imageView.image = UIImage(systemName: "logo.playstation")
            backgroundConfiguration.backgroundColor = .systemBlue
        }
        
        self.backgroundConfiguration = backgroundConfiguration
    }
}
