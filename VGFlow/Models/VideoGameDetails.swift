//
//  VideoGameDetails.swift
//  VGFlow
//
//  Created by Federico Guidi on 28/04/22.
//

import UIKit

struct VideoGameDetails: Codable {
    var hours: Int?
    var status: VideoGameStatus?
    var nowPlaying: Bool
    var starred: Bool
    var starRating: Float?
    var averageStarRating: Float?
    var gameRating: GameRating?
    var averageGameRating: GameRating?
    
    enum CodingKeys: String, CodingKey {
        case hours
        case status
        case nowPlaying
        case starred
        case starRating
        case averageStarRating
        case gameRating
        case averageGameRating
    }
}

extension VideoGameDetails: Hashable { }

enum VideoGameStatus: String, Codable {
    case notStarted = "NotStarted"
    case finished = "Finished"
    case completed = "Completed"
    case unfinished = "Unfinished"
    case abandoned = "Abandoned"
    case unlimited = "Unlimited"
}

extension VideoGameStatus {
    var properties: (UIImage, UIColor, String)
    {
        switch self {
        case .notStarted: return (UIImage(systemName: "sparkles")!, .systemGray, "Non iniziato")
        case .completed: return (UIImage(systemName: "crown.fill")!, .systemOrange, "Completato")
        case .finished: return (UIImage(systemName: "checkmark.circle.fill")!, .systemGreen, "Finito")
        case .unfinished: return (UIImage(systemName: "pause.circle.fill")!, .systemTeal, "Non finito")
        case .abandoned: return (UIImage(systemName: "xmark.circle.fill")!, .systemRed, "Abbandonato")
        case .unlimited: return (UIImage(systemName: "infinity.circle.fill")!, .systemIndigo, "Senza fine")
        }
    }
}

extension VideoGameStatus: Hashable { }

struct GameRating: Codable {
    var gameplay: Float
    var plot: Float
    var music: Float
    var graphics: Float
    var levelDesign: Float
    var longevity: Float
    var ia: Float
    var physics: Float
    
    enum CodingKeys: String, CodingKey {
        case gameplay
        case plot
        case music
        case graphics
        case levelDesign
        case longevity
        case ia
        case physics
    }
}

extension GameRating: Hashable { }
