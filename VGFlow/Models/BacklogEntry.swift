//
//  BacklogEntry.swift
//  VGFlow
//
//  Created by Federico Guidi on 03/05/22.
//

import Foundation

struct BacklogEntry: Codable {
    var user: String
    var videogameId: Int
    var name: String?
    var cover: String?
    var genres: [String]?
    var hours: Int
    var starred: Bool
    var nowPlaying: Bool
    var status: VideoGameStatus
}
