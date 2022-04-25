//
//  SupplementaryItem.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import Foundation
import UIKit

enum SupplementaryItemType {
    case collectionSupplementaryView
    case layoutDecorationView
}

protocol SupplementaryItem {
    associatedtype ViewClass: UICollectionReusableView
    
    var itemType: SupplementaryItemType { get }
    
    var reuseIdentifier: String { get }
    var viewKind: String { get }
    var viewClass: ViewClass.Type { get }
}

extension SupplementaryItem {
    func register(on collectionView: UICollectionView) {
        switch itemType {
        case .collectionSupplementaryView:
            collectionView.register(viewClass.self, forSupplementaryViewOfKind: viewKind, withReuseIdentifier: reuseIdentifier)
        case .layoutDecorationView:
            collectionView.collectionViewLayout.register(viewClass.self, forDecorationViewOfKind: viewKind)
        }
    }
}

enum SupplementaryView: String, CaseIterable, SupplementaryItem {
    case nowPlayingHeader
    case favoritesHeader
    case trendingHeader
    
    var reuseIdentifier: String {
        return rawValue
    }
    
    var viewKind: String {
        return rawValue
    }
    
    var viewClass: UICollectionReusableView.Type {
        switch self {
        case .nowPlayingHeader, .favoritesHeader:
            return IconSectionCollectionReusableView.self
        default:
            return SectionCollectionReusableView.self
        }
    }
    
    var itemType: SupplementaryItemType {
        switch self {
        case .nowPlayingHeader, .favoritesHeader:
            return .collectionSupplementaryView
        default:
            return .layoutDecorationView
        }
    }
}
