//
//  Backlog.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import Foundation

struct Backlog: Codable {
    var totalGames: Int
    var mostPlayedGenre: String
    var playtimeHours: Int
    
    enum CodingKeys: String, CodingKey {
        case totalGames
        case playtimeHours = "totalHours"
        case mostPlayedGenre
    }
}

extension Backlog: Hashable { }
