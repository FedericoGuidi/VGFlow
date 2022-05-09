//
//  UpcomingGameCollectionViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 08/05/22.
//

import UIKit

class UpcomingGameCollectionViewCell: UICollectionViewCell {
    @IBOutlet var coverArt: UIImageView!
    @IBOutlet var videoGameNameLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var videoGameDetailsLabel: UILabel!
    @IBOutlet var videoGameSummaryLabel: UILabel!
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    func configure(with videogame: UpcomingGame, forItemAt indexPath: IndexPath) {
        coverArt.layer.cornerRadius = 10
        
        imageLoadTasks[indexPath] = Task {
            if let url = videogame.cover?.imageURL,
                let image = try? await ImageRequest(path: url).send() {
                if image.size.width > image.size.height {
                    self.coverArt.contentMode = .scaleAspectFit
                }
                self.coverArt.image = image
            }
            imageLoadTasks[indexPath] = nil
        }
        
        videoGameNameLabel.text = videogame.name
        videoGameNameLabel.font = FontKit.roundedFont(ofSize: 18, weight: .semibold)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM y"
        releaseDateLabel.text = dateFormatter.string(from: videogame.releaseDate)
        
        videoGameDetailsLabel.text = videogame.platforms.map { $0.abbreviation }.joined(separator: ", ")
        videoGameSummaryLabel.text = videogame.summary
    }
}
