//
//  TrendingGame.swift
//  VGFlow
//
//  Created by Federico Guidi on 09/05/22.
//

import UIKit

struct TrendingGame: Codable {
    var id: Int
    var name: String
    var cover: String
    var totalNowPlaying: Int
    var averageStarRating: Float
    var bestGameRating: BestGameRating
    
    enum CodingKeys: String, CodingKey {
        case id = "videoGameId"
        case name
        case cover
        case totalNowPlaying
        case averageStarRating
        case bestGameRating
    }
}

extension TrendingGame: Hashable { }

struct BestGameRating: Codable {
    var type: GameRatingType
    var value: Float
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
}

extension BestGameRating: Hashable { }

enum GameRatingType: String, Codable {
    case gameplay
    case plot
    case music
    case graphics
    case levelDesign = "leveldesign"
    case longevity
    case ia
    case physics
}

extension GameRatingType {
    var icon: UIImage
    {
        switch self {
        case .gameplay: return UIImage(systemName: "gamecontroller.fill")!
        case .plot: return UIImage(systemName: "ellipsis.bubble")!
        case .music: return UIImage(systemName: "music.note")!
        case .graphics: return UIImage(systemName: "paintbrush.pointed.fill")!
        case .levelDesign: return UIImage(systemName: "cube.transparent")!
        case .longevity: return UIImage(systemName: "clock.arrow.2.circlepath")!
        case .ia: return UIImage(systemName: "brain.head.profile")!
        case .physics: return UIImage(systemName: "atom")!
        }
    }
}
