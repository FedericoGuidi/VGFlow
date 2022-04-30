//
//  VideoGame.swift
//  VGFlow
//
//  Created by Federico Guidi on 25/04/22.
//

import Foundation

struct VideoGame: Codable {
    var id: Int
    var name: String
    var cover: Cover?
    var releaseDate: Date
    var summary: String
    var involvedCompanies: [InvolvedCompany]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cover
        case releaseDate = "release_date"
        case summary
        case involvedCompanies = "involved_companies"
    }
}

struct Cover: Codable {
    var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}

extension Cover: Hashable { }

struct InvolvedCompany: Codable {
    var company: Company
    var developer: Bool
    var publisher: Bool
    var supporting: Bool
}

struct Company: Codable {
    var id: Int
    var name: String
}

struct Platform: Codable {
    var id: Int
    //var name: String
    var abbreviation: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case abbreviation
    }
}

extension Platform: Hashable { }
