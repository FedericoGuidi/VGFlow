//
//  UserGameRating.swift
//  VGFlow
//
//  Created by Federico Guidi on 02/05/22.
//

import Foundation

struct UserGameRating: Codable {
    var user: String
    var videogameId: Int
    var gameplay: Int
    var plot: Int
    var music: Int
    var graphics: Int
    var levelDesign: Int
    var longevity: Int
    var ia: Int
    var physics: Int
}
