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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

extension VideoGameSearch: Hashable { }
