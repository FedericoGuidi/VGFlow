//
//  APIService.swift
//  VGFlow
//
//  Created by Federico Guidi on 23/04/22.
//

import Foundation

struct LoginRequest: APIRequest {
    typealias Response = BearerToken
    
    var authCode: String?
    
    var path: String { "/login" }
    
    var queryItems: [URLQueryItem]? {
        if let authCode = authCode {
            return [URLQueryItem(name: "ac", value: authCode)]
        } else {
            return nil
        }
    }
}

struct ProfileRequest: APIRequest {
    typealias Response = Profile
    
    var id: String?
    var path: String { "/user" }
    
    var queryItems: [URLQueryItem]? {
        if let id = id {
            return [URLQueryItem(name: "id", value: id)]
        } else {
            return [URLQueryItem(name: "id", value: KeychainItem.currentUserIdentifier)]
        }
    }
}
