//
//  UpcomingGame.swift
//  VGFlow
//
//  Created by Federico Guidi on 08/05/22.
//

import Foundation

struct UpcomingGame: Codable {
    var id: Int
    var name: String
    var cover: Cover?
    var releaseDate: Date
    var platforms: [Platform]
    var summary: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cover
        case releaseDate = "release_date"
        case platforms
        case summary
    }
}

extension UpcomingGame: Hashable { }
