//
//  Profile.swift
//  VGFlow
//
//  Created by Federico Guidi on 19/04/22.
//

import Foundation

struct Profile: Codable {
    var name: String
    var description: String
    var social: [Social]?
    var backlog: Backlog?
    var nowPlaying: [VideoGameCard]?
    var favorites: [VideoGameCard]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case social
        case backlog
        case nowPlaying
        case favorites
    }
}

extension Profile: Hashable { }
