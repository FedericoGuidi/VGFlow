//
//  ProfileHeaderCollectionViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 23/04/22.
//

import UIKit

class ProfileHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    public func configure(with profile: Profile) {
        nameLabel.font = FontKit.roundedFont(ofSize: 24, weight: .semibold)
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
    }
}
