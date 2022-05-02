//
//  StarRating.swift
//  VGFlow
//
//  Created by Federico Guidi on 01/05/22.
//

import Foundation

struct StarRating: Codable {
    var user: String
    var videogameId: Int
    var stars: Float
}
