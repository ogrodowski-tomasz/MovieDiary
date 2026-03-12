import Foundation
import CoreNetwork

public enum CommonEndpoint: Sendable {

    case configuration
    case genres(ListType)
    case langauges
    
    public var endpoint: Endpoint {
        switch self {
        case .configuration:
            return .init(path: "/configuration")
        case let .genres(type):
            return .init(path: "/genre/\(type.endpointPathComponent)/list")
        case .langauges:
            return .init(path: "/configuration/languages")
        }
    }
}

