//
//  VideoGameSearchTableViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 27/04/22.
//

import UIKit

class VideoGameSearchTableViewCell: UITableViewCell {

    var videoGameId: Int?
    @IBOutlet var videogameNameLabel: UILabel!
    @IBOutlet var coverView: UIImageView!
    @IBOutlet var platformsCollectionView: UICollectionView!
    
    var platforms: [Platform]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coverView.layer.cornerRadius = 10
        
        let flowLayout = LeftAlignedFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        self.platformsCollectionView.collectionViewLayout = flowLayout
        //self.platformsCollectionView.showsHorizontalScrollIndicator = false
        
        // Comment if you set Datasource and delegate in .xib
        self.platformsCollectionView.dataSource = self
        self.platformsCollectionView.delegate = self
        self.platformsCollectionView.backgroundColor = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension VideoGameSearchTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith(platforms: [Platform]?) {
        if let platforms = platforms {
            self.platforms = platforms
        } else {
            self.platforms = nil
        }
        self.platformsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.platforms?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Set the data for each cell (color and color name)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformCell", for: indexPath) as? PlatformCollectionViewCell {
            cell.configure(with: platforms![indexPath.item].abbreviation)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
}
