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
}

extension VideoGameCard: Hashable { }
