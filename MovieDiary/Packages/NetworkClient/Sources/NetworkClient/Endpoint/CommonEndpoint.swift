import Foundation
import Models

public enum CommonEndpoint: Endpoint {

    case configuration
    case genres(ListType)
    case langauges
    
    public func path() -> String {
        switch self {
        case .configuration:
            "/configuration"
        case let .genres(type):
            "/genre/\(type.endpointPathComponent)/list"
        case .langauges:
            "/configuration/languages"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        default: nil
        }
    }
}
