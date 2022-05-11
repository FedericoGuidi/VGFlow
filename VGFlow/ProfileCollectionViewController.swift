//
//  ProfileCollectionViewController.swift
//  VGFlow
//
//  Created by Federico Guidi on 23/04/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class ProfileCollectionViewController: UICollectionViewController {

    
    
    var profileRequestTask: Task<Void, Never>? = nil
    deinit {
        profileRequestTask?.cancel()
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        enum Section: Hashable {
            case profileHeader
            case socialContacts
            case myBacklog
            case nowPlaying
            case favorites
        }
        
        enum Item: Hashable {
            case profileDetails(_ profile: Profile)
            case social(_ social: Social)
            case myBacklog(_ backlog: Backlog)
            case nowPlaying(_ videogame: VideoGameCard)
            case favorites(_ videogame: VideoGameCard)
            
            func getVideoGame() -> VideoGameCard? {
                switch self {
                case .nowPlaying(let vg):
                    return vg
                case .favorites(let vg):
                    return vg
                default:
                    return nil
                }
            }
        }
    }
    
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    struct Model {
        var profile: Profile?
    }
    
    var model = Model()
    var dataSource: DataSourceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        for supplementaryView in SupplementaryView.allCases {
            supplementaryView.register(on: collectionView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProfile()
    }
    
    func updateProfile() {
        profileRequestTask?.cancel()
        profileRequestTask = Task {
            if let profile = try? await ProfileRequest(id: "001309.bca6a7cae40c4815995d19522fdde5a0.1537").send() {
                self.model.profile = profile
            }
            self.updateCollectionView()
            
            profileRequestTask = nil
        }
    }
    
    func updateCollectionView() {
        var sectionIDs = [ViewModel.Section]()
        
        var itemsBySection: [ViewModel.Section: [ViewModel.Item]] = [.profileHeader: [ViewModel.Item.profileDetails(model.profile!)]]
        sectionIDs.append(.profileHeader)
        
        itemsBySection[.socialContacts] = model.profile?.social?.map { ViewModel.Item.social($0) }
        sectionIDs.append(.socialContacts)
        
        itemsBySection[.myBacklog] = [ViewModel.Item.myBacklog(model.profile!.backlog!)]
        sectionIDs.append(.myBacklog)
        
        itemsBySection[.nowPlaying] = model.profile?.nowPlaying?.map { ViewModel.Item.nowPlaying($0) }
        sectionIDs.append(.nowPlaying)
        
        itemsBySection[.favorites] = model.profile?.favorites?.map { ViewModel.Item.favorites($0) }
        sectionIDs.append(.favorites)
        
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .profileDetails(let profile):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeader", for: indexPath) as! ProfileHeaderCollectionViewCell
                cell.configure(with: profile)
                return cell
            case .social(let social):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialContactCollectionViewCell.reuseIdentifier, for: indexPath) as! SocialContactCollectionViewCell
                cell.configure(with: social)
                return cell
            case .myBacklog(let backlog):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBacklogCollectionViewCell.reuseIdentifier, for: indexPath) as! MyBacklogCollectionViewCell
                cell.configure(with: backlog)
                return cell
            case .nowPlaying(let videogame), .favorites(let videogame):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoGameCollectionViewCell.reuseIdentifier, for: indexPath) as! VideoGameCollectionViewCell
                cell.configure(with: videogame, forItemAt: indexPath)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let elementKind = SupplementaryView(rawValue: kind) else { return nil }
        
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind.viewKind, withReuseIdentifier: elementKind.reuseIdentifier, for: indexPath)
        
            switch elementKind {
            case .nowPlayingHeader:
                let header = view as! IconSectionCollectionReusableView
                header.setTitle("Now playing", with: "play.circle")
                return header
            case .favoritesHeader:
                let header = view as! IconSectionCollectionReusableView
                header.setTitle("Preferiti", with: "heart.fill")
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
            case .profileHeader:
                let profileItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(125))
                let profileItem = NSCollectionLayoutItem(layoutSize: profileItemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(125))
                let profileGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: profileItem, count: 1)
                
                let profileSection = NSCollectionLayoutSection(group: profileGroup)
                return profileSection
                
            case .socialContacts:
                let socialItemSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .fractionalHeight(0.90))
                let socialItem = NSCollectionLayoutItem(layoutSize: socialItemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(0.1), heightDimension: .absolute(36))
                let socialGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [socialItem])
                socialGroup.interItemSpacing = .fixed(10)
                
                let socialSection = NSCollectionLayoutSection(group: socialGroup)
                socialSection.interGroupSpacing = 10
                socialSection.orthogonalScrollingBehavior = .groupPaging
                socialSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
                return socialSection
                
            case .myBacklog:
                let myBacklogItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(185))
                let myBacklogItem = NSCollectionLayoutItem(layoutSize: myBacklogItemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(185))
                let myBacklogGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: myBacklogItem, count: 1)
                
                let myBacklogSection = NSCollectionLayoutSection(group: myBacklogGroup)
                myBacklogSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
                return myBacklogSection
                
            case .nowPlaying, .favorites:
                let nowPlayingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(0.4))
                let nowPlayingItem = NSCollectionLayoutItem(layoutSize: nowPlayingItemSize)
                nowPlayingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.42))
                let nowPlayingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: nowPlayingItem, count: 3)
                
                let nowPlayingSection = NSCollectionLayoutSection(group: nowPlayingGroup)
                nowPlayingSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
                nowPlayingSection.orthogonalScrollingBehavior = .groupPagingCentered
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let header: NSCollectionLayoutBoundarySupplementaryItem
                if sectionType == .nowPlaying {
                    header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SupplementaryView.nowPlayingHeader.viewKind, alignment: .top)
                } else {
                    header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SupplementaryView.favoritesHeader.viewKind, alignment: .top)
                }
                
                nowPlayingSection.boundarySupplementaryItems = [header]
                
                return nowPlayingSection
            }
        }
        
        return layout
    }
    
    @IBAction func modalDismissed(segue: UIStoryboardSegue) {
        guard segue.identifier == "addToBacklog" else { return }
        let souceViewController = segue.source as! AddEditVideoGameViewController
        
        if let backlogEntry = souceViewController.backlogEntry {
            Task {
                try? await BacklogEntryRequest(backlogEntry: backlogEntry).send()
                updateProfile()
            }
        }
    }
    
    @IBAction func modalDismissedForDelete(segue: UIStoryboardSegue) {
        guard segue.identifier == "removeFromBacklog" else { return }
        
        let souceViewController = segue.source as! AddEditVideoGameViewController
        
        if let videogame = souceViewController.videoGame {
            Task {
                try? await RemoveEntryRequest(videogameId: videogame.id).send()
                updateProfile()
            }
        }
    }
    
    @IBSegueAction func showVideoGameDetail(_ coder: NSCoder, sender: VideoGameCollectionViewCell?) -> VideoGameDetailViewController? {
        
        guard let cell = sender,
              let indexPath = collectionView.indexPath(for: cell),
              let item = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let videogame = item.getVideoGame()!
        
        return VideoGameDetailViewController(coder: coder, source: .videoGameCard(videogame))
    }
}
