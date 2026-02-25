//
//  TokenResponse.swift
//  MovieDiary
//
//  Created by itcraft on 25/02/2026.
//


import SwiftUI

struct TokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    static var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }
}