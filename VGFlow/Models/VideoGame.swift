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
    var storyline: String
    var involvedCompanies: [InvolvedCompany]?
    var platforms: [Platform]?
    var genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cover
        case releaseDate = "release_date"
        case summary
        case storyline
        case involvedCompanies = "involved_companies"
        case platforms
        case genres
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
    var name: String
    var abbreviation: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation
    }
}

extension Platform: Hashable { }

struct Genre: Codable {
    var id: Int
    var name: String
}
