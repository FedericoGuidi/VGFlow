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
            //case backlog
            //case nowPlaying
            //case favorites
        }
        
        enum Item: Hashable {
            case profileDetails(_ profile: Profile)
            case social(_ social: Social)
        }
    }
    
    struct Model {
        var profile: Profile?
    }
    
    var model = Model()
    var dataSource: DataSourceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileRequestTask = Task {
            if let profile = try? await ProfileRequest().send() {
                self.model.profile = profile
                self.model.profile?.social = [Social(type: .nintendoSwitch, value: "1234-5678-9101"),
                                              Social(type: .xbox, value: "Fedrive"),
                                              Social(type: .playstation, value: "Fedrive")]
            }
            self.updateCollectionView()
            
            profileRequestTask = nil
        }
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
    }
    
    func update() {
        
    }
    
    func updateCollectionView() {
        var sectionIDs = [ViewModel.Section]()
        
        var itemsBySection: [ViewModel.Section: [ViewModel.Item]] = [.profileHeader: [ViewModel.Item.profileDetails(model.profile!)]]
        sectionIDs.append(.profileHeader)
        
        itemsBySection[.socialContacts] = model.profile?.social?.map { ViewModel.Item.social($0) }
        sectionIDs.append(.socialContacts)
        
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
            }
        }
        
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch self.dataSource.snapshot().sectionIdentifiers[sectionIndex] {
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
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(0), heightDimension: .absolute(36))
                let socialGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [socialItem])
                socialGroup.interItemSpacing = .fixed(10)
                
                let socialSection = NSCollectionLayoutSection(group: socialGroup)
                socialSection.interGroupSpacing = 10
                socialSection.orthogonalScrollingBehavior = .groupPaging
                socialSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
                
                return socialSection
            }
        }
        
        return layout
    }
}
