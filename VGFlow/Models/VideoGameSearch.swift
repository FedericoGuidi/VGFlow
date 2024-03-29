//
//  VideoGameSearch.swift
//  VGFlow
//
//  Created by Federico Guidi on 26/04/22.
//

import Foundation

struct VideoGameSearch: Codable {
    var id: Int
    var name: String
    var cover: Cover?
    var platforms: [PlatformLite]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cover
        case platforms
    }
}

extension VideoGameSearch: Hashable { }

struct PlatformLite: Codable {
    var id: Int
    var abbreviation: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case abbreviation
    }
}

extension PlatformLite: Hashable { }
