//
//  SearchResultsTableViewController.swift
//  VGFlow
//
//  Created by Federico Guidi on 26/04/22.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    let tableViewCellIdentifier = "VideoGameCell"
    
    var filteredVideogames = [VideoGameSearch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0,bottom: 0,right: 0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredVideogames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! SearchResultsTableViewCell
        let videogame = filteredVideogames[indexPath.row]
        
        cell.videoGameId = videogame.id
        cell.videogameNameLabel.text = videogame.name

        return cell
    }
    @IBSegueAction func showVideoGameDetail(_ coder: NSCoder, sender: Any?) -> VideoGameDetailViewController? {
        guard let cell = sender as? SearchResultsTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let videogame = VideoGameCard(id: cell.videoGameId!, name: cell.videogameNameLabel.text!)
        return VideoGameDetailViewController(coder: coder, videogame: videogame)
    }
}
