//
//  SearchResultsTableViewCell.swift
//  VGFlow
//
//  Created by Federico Guidi on 26/04/22.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    var videoGameId: Int?
    
    @IBOutlet var videogameNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
