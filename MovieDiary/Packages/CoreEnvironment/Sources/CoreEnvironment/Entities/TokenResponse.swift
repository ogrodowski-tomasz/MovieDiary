import SwiftUI

struct TokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    static var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
}
