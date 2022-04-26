//
//  VideoGame.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import Foundation

struct VideoGameCard: Codable {
    var id: Int
    var name: String
    var coverURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coverURL = "cover"
    }
}

extension VideoGameCard: Hashable { }
