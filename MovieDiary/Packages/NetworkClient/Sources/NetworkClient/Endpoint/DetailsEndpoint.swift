import Foundation
import Models

public enum DetailsEndpoint: Sendable {
    case details(ListType, id: Int)
    case recommendations(ListType, id: Int)
    case credits(ListType, id: Int)
}

extension DetailsEndpoint: Endpoint {
    
    public func path() -> String {
        switch self {
        case let .details(listType, id):
            return "/\(listType.endpointPathComponent)/\(id)"
        case let .recommendations(listType,id):
            return "/\(listType.endpointPathComponent)/\(id)/recommendations"
        case let .credits(listType,id):
            return "/\(listType.endpointPathComponent)/\(id)/credits"
        }
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }
}
