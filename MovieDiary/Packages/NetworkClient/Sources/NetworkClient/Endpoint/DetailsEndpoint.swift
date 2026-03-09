import Foundation
import Models

public enum DetailsEndpoint: Sendable {
    case details(ListType, id: Int)
    case recommendations(id: Int)
}

extension DetailsEndpoint: Endpoint {
    
    public func path() -> String {
        switch self {
        case let .details(listType, id):
            return "/\(listType.endpointPathComponent)/\(id)"
        case let .recommendations(id):
            return "/movie/\(id)/recommendations"
        }
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }
}
