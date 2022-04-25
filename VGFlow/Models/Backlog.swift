//
//  Backlog.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import Foundation

struct Backlog: Codable {
    var numberOfGames: Int
    var mostPlayedGenre: String
    var playtimeHours: Int
}

extension Backlog: Hashable { }
