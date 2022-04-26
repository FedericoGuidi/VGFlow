//
//  APIRequest.swift
//  VGFlow
//
//  Created by Federico Guidi on 21/04/22.
//

import Foundation
import UIKit

protocol APIRequest {
    associatedtype Response
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
    var postData: Data? { get }
}

extension APIRequest {
    var host: String { "vgflowapi.azurewebsites.net" }
}

extension APIRequest {
    var queryItems: [URLQueryItem]? { nil }
    var postData: Data? { nil }
}

extension APIRequest {
    var request: URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        
        if let data = postData {
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
        }
        
        //request.setValue("Bearer \(KeychainItem.currentBearer)", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer eyJraWQiOiJXNldjT0tCIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmZlZGVyaWNvZ3VpZGkuVkdGbG93IiwiZXhwIjoxNjUwNTcxMjE4LCJpYXQiOjE2NTA0ODQ4MTgsInN1YiI6IjAwMTMwOS5iY2E2YTdjYWU0MGM0ODE1OTk1ZDE5NTIyZmRkZTVhMC4xNTM3IiwiYXRfaGFzaCI6IllTeTZZQnhUaWhwcmQ2aUJFRVNaX0EiLCJlbWFpbCI6InFjcmNqcndodGNAcHJpdmF0ZXJlbGF5LmFwcGxlaWQuY29tIiwiZW1haWxfdmVyaWZpZWQiOiJ0cnVlIiwiaXNfcHJpdmF0ZV9lbWFpbCI6InRydWUiLCJhdXRoX3RpbWUiOjE2NTA0ODQ3NjksIm5vbmNlX3N1cHBvcnRlZCI6dHJ1ZX0.ltJ_u_OlOColyG5i9tCKMs4etQwcu-eII231aPApMA1IPcV2NKh8uVhVF-7GRiukqWtj2zk2l_NQG1X8qPfGI88Vl1Tiql3nuW3NWWbpLSVQWHtIm5w7MIbY3jaG3HyADVqZG-nSYR-lVDnzSfXhOqxpNoIpJutOP_-J7Ekyfch1x8EPgwGB_8FXWfaHcdgqa5I5YVcFM1UnNVOPkcLqea9W0BlDzw1IP7GxVJx7N81BK_vpWoCgE9KGBmnGVeaRD2yCg2fG55LrBLzii8kFY-umCG1p6XFwYCRG69KSPDe-b7gnDxYsz5dOhPhABgYS7ybABwzVelFBBfbuC3ED4A", forHTTPHeaderField: "Authorization")
        return request
    }
}

enum APIRequestError: Error {
    case itemsNotFound
    case requestFailed
}


extension APIRequest where Response: Decodable {
    func send() async throws -> Response {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIRequestError.itemsNotFound
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(Response.self, from: data)
        
        return decoded
    }
}

enum ImageRequestError: Error {
    case couldNotInitializeFromData
    case imageDataMissing
}

extension APIRequest where Response == UIImage {
    func send() async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ImageRequestError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageRequestError.imageDataMissing
        }
        
        return image
    }
}

extension APIRequest where Response == BearerToken {
    var request: URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
        return request
    }
}

extension APIRequest {
    func send() async throws -> Void {
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIRequestError.requestFailed
        }
    }
}
