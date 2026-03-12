import Foundation

public typealias JSONBodyCovertible = Encodable & Sendable

public struct Endpoint: Sendable {

    let path: String
    let queryItems: [URLQueryItem]?
    let jsonValue: JSONBodyCovertible?

    public init(path: String, queryItems: [URLQueryItem]? = nil, jsonValue: JSONBodyCovertible? = nil) {
        self.path = path
        self.queryItems = queryItems
        self.jsonValue = jsonValue
    }
    
    public var description: String {
        return "\(path)?" + (queryItems.map(\.debugDescription) ?? "")
    }
}
