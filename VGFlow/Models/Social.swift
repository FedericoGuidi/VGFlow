//
//  Social.swift
//  VGFlow
//
//  Created by Federico Guidi on 23/04/22.
//

import Foundation

enum SocialType: Codable {
    case nintendoSwitch
    case xbox
    case playstation
}

struct Social: Codable {
    var type: SocialType
    var value: String
}

extension Social: Hashable { }
