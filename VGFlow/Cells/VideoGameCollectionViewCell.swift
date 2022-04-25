//
//  VideoGameCollectionViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import UIKit

class VideoGameCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "VideoGameCard"
    
    @IBOutlet var coverArtContentView: UIView!
    @IBOutlet var coverArtView: UIImageView!
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    func configure(with videogame: VideoGameCard, forItemAt indexPath: IndexPath) {
        coverArtView.layer.cornerRadius = 10
        coverArtContentView.layer.cornerRadius = 10
        
        imageLoadTasks[indexPath] = Task {
            if let url = videogame.coverURL,
               let image = try? await ImageRequest(path: url).send() {
                coverArtView.image = image
            }
            imageLoadTasks[indexPath] = nil
        }
    }
}
