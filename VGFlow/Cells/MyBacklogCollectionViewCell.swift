//
//  MyBacklogCollectionViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import UIKit

class MyBacklogCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MyBacklog"
    @IBOutlet var myBacklogLabel: UILabel!
    @IBOutlet var backlogDetailButton: UIButton!
    @IBOutlet var mostPlayedLabel: UILabel!
    @IBOutlet var mostPlayedValueLabel: UILabel!
    @IBOutlet var playtimeLabel: UILabel!
    @IBOutlet var playtimeValueLabel: UILabel!
    @IBOutlet var numberOfGamesLabel: UILabel!
    @IBOutlet var numberOfGamesValueLabel: UILabel!
    
    func configure(with backlog: Backlog) {
        myBacklogLabel.textColor = .white
        backlogDetailButton.tintColor = .white
        mostPlayedLabel.textColor = .white
        mostPlayedValueLabel.textColor = .white
        playtimeLabel.textColor = .white
        playtimeValueLabel.textColor = .white
        numberOfGamesLabel.textColor = .white
        numberOfGamesValueLabel.textColor = .white
        
        numberOfGamesValueLabel.text = String(backlog.totalGames)
        mostPlayedValueLabel.text = backlog.mostPlayedGenre
        playtimeValueLabel.text = "\(backlog.playtimeHours) ore"
        
        var backgroundConfiguration = UIBackgroundConfiguration.clear()
        backgroundConfiguration.cornerRadius = 20
        backgroundConfiguration.backgroundColor = .systemBlue
        self.backgroundConfiguration = backgroundConfiguration
    }
}
