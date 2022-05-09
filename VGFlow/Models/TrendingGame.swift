//
//  TrendingGame.swift
//  VGFlow
//
//  Created by Federico Guidi on 09/05/22.
//

import Foundation

struct TrendingGame: Codable {
    var id: Int
    var cover: String
    var totalNowPlaying: Int
    var averageStarRating: Float
    var bestGameRating: BestGameRating
    
    enum CodingKeys: String, CodingKey {
        case id = "videoGameId"
        case cover
        case totalNowPlaying
        case averageStarRating
        case bestGameRating
    }
}

extension TrendingGame: Hashable { }

struct BestGameRating: Codable {
    var type: String
    var value: Float
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
}

extension BestGameRating: Hashable { }
