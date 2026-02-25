import Foundation

protocol Endpoint: Sendable {
    func path() -> String
    func queryItems() -> [URLQueryItem]?
    var jsonValue: Encodable? { get }
    var mockFileName: String? { get }
}

extension Endpoint {
    var jsonValue: Encodable? {
        return nil
    }
    
    var mockFileName: String? {
        return nil
    }
}
