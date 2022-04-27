//
//  PlatformCollectionViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 27/04/22.
//

import UIKit

class PlatformCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var platformName: UILabel!
    
    func configure(with name: String) {
        var backgroundConfiguration = UIBackgroundConfiguration.clear()
        backgroundConfiguration.cornerRadius = 10
        backgroundConfiguration.backgroundColor = .lightGray.withAlphaComponent(0.5)
        self.backgroundConfiguration = backgroundConfiguration
        platformName.font = UIFont.systemFont(ofSize: 12)
        platformName.text = name
    }
}
