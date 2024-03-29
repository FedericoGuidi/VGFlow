//
//  Social.swift
//  VGFlow
//
//  Created by Federico Guidi on 23/04/22.
//

import Foundation

enum SocialType: String, Codable, CaseIterable {
    case nintendoSwitch
    case xbox
    case playstation
    case steam
}

struct Social: Codable {
    var type: SocialType
    var value: String
}

extension Social: Hashable { }
