//
//  TrendingCollectionViewController.swift
//  VGFlow
//
//  Created by Federico Guidi on 26/04/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class TrendingViewController: UIViewController {
    //@IBOutlet var searchBarView: UIView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    /// Search controller to help us with filtering.
    private var searchController: UISearchController!
    
    /// Secondary search results table view.
    private var searchResultsController: SearchResultsTableViewController!
    
    private var searchResults = [VideoGameSearch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .quaternarySystemFill
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        searchResultsController = self.storyboard?.instantiateViewController(withIdentifier: "searchResults") as? SearchResultsTableViewController
        searchResultsController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        
        searchBar = searchController.searchBar
        searchBar.placeholder = "Cerca un videogioco..."
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .systemBackground
        
        navigationItem.titleView = self.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    @IBAction func modalDismissed(segue: UIStoryboardSegue) {
        
    }
}

extension TrendingViewController: UITableViewDelegate {
    
    
    
}

// MARK: - UISearchBarDelegate

extension TrendingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        Task {
            do {
                let videogames = try await SearchVideoGameRequest(query: searchBar.text).send()
                
                searchResults = videogames
                
                if let resultsController = searchController.searchResultsController as? SearchResultsTableViewController {
                    resultsController.filteredVideogames = searchResults
                    resultsController.tableView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }
    }
}

extension TrendingViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        if let resultsController = searchController.searchResultsController as? SearchResultsTableViewController {
            searchResults = []
            resultsController.tableView.reloadData()
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
}

extension TrendingViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        //let searchResults = ["abcde","cdefg","efghi","ghijk"]
        
        // Strip out all the leading and trailing spaces.
        //let whitespaceCharacterSet = CharacterSet.whitespaces
        //let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        
        //let filteredResults = searchResults.filter { $0.contains(strippedString) }
        
        // Apply the filtered results to the search results table.
        /*if let resultsController = searchController.searchResultsController as? SearchResultsTableViewController {
            resultsController.filteredVideogames = searchResults
            resultsController.tableView.reloadData()
        }*/
    }
    
}
