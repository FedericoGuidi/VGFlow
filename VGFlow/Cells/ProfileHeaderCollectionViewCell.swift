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
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
    }
}
