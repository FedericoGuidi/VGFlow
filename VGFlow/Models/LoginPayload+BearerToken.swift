//
//  Keychain.swift
//  VGFlow
//
//  Created by Federico Guidi on 19/04/22.
//

import Foundation

struct LoginPayload: Codable {
    let authorizationCode: String
    let appleID: String
    let fullName: String?
    let email: String?
}

struct BearerToken: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let idToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
    }
}


