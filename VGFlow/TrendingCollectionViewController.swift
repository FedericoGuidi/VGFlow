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
    
    var upcomingTrendingRequestsTask: Task<Void, Never>? = nil
    deinit {
        upcomingTrendingRequestsTask?.cancel()
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        enum Section: Hashable {
            case trendingGames
            case upcomingGames
        }
        
        enum Item: Hashable {
            case trendingGame(_ videogame: TrendingGame)
            case upcomingGame(_ videogame: UpcomingGame)
            
            func getVideoGame() -> Any? {
                switch self {
                case .upcomingGame(let vg):
                    return vg
                case .trendingGame(let vg):
                    return vg
                }
            }
        }
    }
    
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    struct Model {
        var trendingGames: [TrendingGame]?
        var upcomingGames: [UpcomingGame]?
    }
    
    var model = Model()
    var dataSource: DataSourceType!
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
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
        
        initSearchBar()
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        for supplementaryView in SupplementaryView.allCases {
            supplementaryView.register(on: collectionView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
    }
    
    func update() {
        upcomingTrendingRequestsTask?.cancel()
        upcomingTrendingRequestsTask = Task {
            if let trendingGames = try? await TrendingGamesRequest().send() {
                self.model.trendingGames = trendingGames
            }
            if let upcomingGames = try? await UpcomingGamesRequest().send() {
                self.model.upcomingGames = upcomingGames
            }
            self.updateCollectionView()
            upcomingTrendingRequestsTask = nil
        }
    }
    
    func updateCollectionView() {
        var sectionIDs = [ViewModel.Section]()
        var itemsBySection = [ViewModel.Section: [ViewModel.Item]]()
        
        itemsBySection[.trendingGames] = model.trendingGames!.map { ViewModel.Item.trendingGame($0) }
        sectionIDs.append(.trendingGames)
        
        itemsBySection[.upcomingGames] = model.upcomingGames!.map { ViewModel.Item.upcomingGame($0) }
        sectionIDs.append(.upcomingGames)
    
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection)
    }
    
    private func initSearchBar() {
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
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .upcomingGame(let videogame):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingGame", for: indexPath) as! UpcomingGameCollectionViewCell
                cell.configure(with: videogame, forItemAt: indexPath)
                return cell
            case .trendingGame(let videogame):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingGame", for: indexPath) as! TrendingGameCollectionViewCell
                cell.configure(with: videogame, forItemAt: indexPath)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let elementKind = SupplementaryView(rawValue: kind) else { return nil }
        
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind.viewKind, withReuseIdentifier: elementKind.reuseIdentifier, for: indexPath)
        
            switch elementKind {
            case .upcomingGamesHeader:
                let header = view as! IconSectionCollectionReusableView
                header.setTitle("Prossime uscite", with: "hourglass")
                
                header.backgroundColor = .systemBackground
                
                return header
            case .trendingGamesHeader:
                let header = view as! IconSectionCollectionReusableView
                header.setTitle("I più votati", with: "star.fill")
                
                header.backgroundColor = .systemBackground
                
                return header
            default:
                return nil
            }
        }
        
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sectionType {
            case .upcomingGames:
                let upcomingGameItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
                let upcomingGameItem = NSCollectionLayoutItem(layoutSize: upcomingGameItemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
                let upcomingGameGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: upcomingGameItem, count: 1)
                
                let upcomingGameSection = NSCollectionLayoutSection(group: upcomingGameGroup)
                upcomingGameSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SupplementaryView.upcomingGamesHeader.viewKind, alignment: .top)
                header.pinToVisibleBounds = true
                upcomingGameSection.boundarySupplementaryItems = [header]
                
                return upcomingGameSection
            case .trendingGames:
                let trendingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(0.52))
                let trendingItem = NSCollectionLayoutItem(layoutSize: trendingItemSize)
                trendingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.55))
                let trendingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: trendingItem, count: 3)
                
                let trendingSection = NSCollectionLayoutSection(group: trendingGroup)
                trendingSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
                trendingSection.orthogonalScrollingBehavior = .groupPagingCentered
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SupplementaryView.trendingGamesHeader.viewKind, alignment: .top)
                header.pinToVisibleBounds = true
                trendingSection.boundarySupplementaryItems = [header]
                
                return trendingSection
            }
        }
        
        return layout
    }
    
    @IBSegueAction func showVideoGameDetail(_ coder: NSCoder, sender: UpcomingGameCollectionViewCell?) -> VideoGameDetailViewController? {
        guard let cell = sender,
              let indexPath = collectionView.indexPath(for: cell),
              let item = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let videogame = item.getVideoGame() as! UpcomingGame
        
        return VideoGameDetailViewController(coder: coder, source: .upcomingGame(videogame))
    }
    
    @IBAction func modalDismissed(segue: UIStoryboardSegue) {
        guard segue.identifier == "addToBacklog" else { return }
        let souceViewController = segue.source as! AddEditVideoGameViewController
        
        if let backlogEntry = souceViewController.backlogEntry {
            Task {
                try? await BacklogEntryRequest(backlogEntry: backlogEntry).send()
            }
        }
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
