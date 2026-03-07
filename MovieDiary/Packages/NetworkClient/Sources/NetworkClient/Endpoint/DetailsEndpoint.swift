import Foundation

public enum DetailsEndpoint: Sendable {
    case movie(id: Int)
    case recommendations(id: Int)
}

extension DetailsEndpoint: Endpoint {
    
    public func path() -> String {
        switch self {
        case let .movie(id):
            return "/movie/\(id)"
        case let .recommendations(id):
            return "/movie/\(id)/recommendations"
        }
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }
}
