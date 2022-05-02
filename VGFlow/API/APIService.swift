//
//  APIService.swift
//  VGFlow
//
//  Created by Federico Guidi on 23/04/22.
//

import Foundation
import UIKit

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
    var path: String { "/profile" }
    
    var queryItems: [URLQueryItem]? {
        if let id = id {
            return [URLQueryItem(name: "id", value: id)]
        } else {
            return [URLQueryItem(name: "id", value: KeychainItem.currentUserIdentifier)]
        }
    }
}

struct ImageRequest: APIRequest {
    typealias Response = UIImage
    
    var path: String
    
    var request: URLRequest {
        return URLRequest(url: URL(string: path)!)
    }
}

struct VideoGameRequest: APIRequest {
    typealias Response = VideoGame
    
    var id: Int
    var path: String { "/videogames/\(id)" }
}

struct SearchVideoGameRequest: APIRequest {
    typealias Response = [VideoGameSearch]
    
    var path: String { "/videogames/search"}
    var query: String?
    
    var queryItems: [URLQueryItem]? {
        if let query = query {
            return [URLQueryItem(name: "search", value: query)]
        } else {
            return nil
        }
    }
}

struct VideoGameDetailsRequest: APIRequest {
    typealias Response = VideoGameDetails
    
    var path: String { "/videogame/details" }
    var videogameId: Int?
    
    var queryItems: [URLQueryItem]? {
        if let videogameId = videogameId {
            return [URLQueryItem(name: "vid", value: String(videogameId)),
                    //URLQueryItem(name: "uid", value: KeychainItem.currentUserIdentifier)]
                    URLQueryItem(name: "uid", value: "001309.bca6a7cae40c4815995d19522fdde5a0.1537")]
        } else {
            return nil
        }
    }
}

struct RateVideoGameByStarsRequest: APIRequest {
    typealias Response = Void
    
    var path: String { "/videogame/ratebystars" }
    var starRating: StarRating
    
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(starRating)
    }
}

struct RateVideoGameByGameRatingRequest: APIRequest {
    typealias Response = Void
    
    var path: String { "/videogame/ratebygamerating" }
    var gameRating: UserGameRating
    
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(gameRating)
    }
}
