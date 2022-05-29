//
//  User.swift
//  VGFlow
//
//  Created by Federico Guidi on 29/05/22.
//

import Foundation

struct User: Codable {
    var appleId: String
    var name: String
    var email: String
    var description: String
    var social: [Social]?
    
    enum CodingKeys: String, CodingKey {
        case appleId
        case name
        case email
        case description
        case social
    }
}

extension User: Hashable { }
