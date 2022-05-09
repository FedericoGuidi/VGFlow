//
//  TrendingGameCollectionViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 08/05/22.
//

import UIKit

class TrendingGameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var coverArt: UIImageView!
    @IBOutlet var starRating: UIStarRatingView!
    @IBOutlet var totalNowPlayingLabel: UILabel!
    @IBOutlet var bestRatingIcon: UIImageView!
    @IBOutlet var bestRatingLabel: UILabel!
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    func configure(with videogame: TrendingGame, forItemAt indexPath: IndexPath) {
        self.layer.cornerRadius = 10
        self.coverArt.layer.cornerRadius = 10
        self.starRating.backgroundColor = .clear
        self.starRating.rating = videogame.averageStarRating
        self.starRating.starColor = .systemYellow
        self.totalNowPlayingLabel.text = String(videogame.totalNowPlaying)
        
        imageLoadTasks[indexPath] = Task {
            if let image = try? await ImageRequest(path: videogame.cover).send() {
                if image.size.width > image.size.height {
                    self.coverArt.contentMode = .scaleAspectFit
                }
                self.coverArt.image = image
            }
            imageLoadTasks[indexPath] = nil
        }
    }
}
