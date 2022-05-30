//
//  Search.swift
//  VGFlow
//
//  Created by Federico Guidi on 30/05/22.
//

import Foundation

struct Search: Codable {
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case value
    }
}
