import Foundation
import CoreNetwork

public enum CommonEndpoint: Sendable {

    case configuration
    case genres(ListType, language: String)
    case langauges
    
    public var endpoint: Endpoint {
        switch self {
        case .configuration:
            return .init(path: "/configuration")
        case let .genres(type, language):
            return .init(
                path: "/genre/\(type.endpointPathComponent)/list",
                queryItems: [.init(
                    name: "language",
                    value: language
                )]
            )
        case .langauges:
            return .init(path: "/configuration/languages")
        }
    }
}

