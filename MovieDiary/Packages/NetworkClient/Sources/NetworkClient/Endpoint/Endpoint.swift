import Foundation

public protocol Endpoint: Sendable {
    func path() -> String
    func queryItems() -> [URLQueryItem]?
    var jsonValue: Encodable? { get }
    var mockFileName: String? { get }
}

public extension Endpoint {
    var jsonValue: Encodable? {
        return nil
    }
    
    var mockFileName: String? {
        return nil
    }
}
