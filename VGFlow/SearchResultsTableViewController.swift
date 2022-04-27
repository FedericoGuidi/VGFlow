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
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! VideoGameSearchTableViewCell
        let videogame = filteredVideogames[indexPath.row]
        
        cell.videoGameId = videogame.id
        cell.videogameNameLabel.text = videogame.name
        cell.coverView.image = nil
        cell.updateCellWith(platforms: videogame.platforms?.filter { !$0.abbreviation.isEmpty})
        
        imageLoadTasks[indexPath] = Task {
            do {
                if let url = videogame.cover?.imageURL {
                    let image = try await ImageRequest(path: url).send()
                    if image.size.width >= image.size.height {
                        cell.coverView.contentMode = .scaleAspectFit
                    } else {
                        cell.coverView.contentMode = .scaleAspectFill
                    }
                    cell.coverView.image = image
                }
            } catch {
                print(error)
            }
            imageLoadTasks[indexPath] = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageLoadTasks[indexPath]?.cancel()
    }
    
    @IBSegueAction func showVideoGameDetail(_ coder: NSCoder, sender: Any?) -> VideoGameDetailViewController? {
        guard let cell = sender as? VideoGameSearchTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let videogame = VideoGameCard(id: cell.videoGameId!, name: cell.videogameNameLabel.text!)
        return VideoGameDetailViewController(coder: coder, videogame: videogame)
    }
}
