import Foundation

public enum DetailsEndpoint: Sendable {
    case movie(id: Int)
}

extension DetailsEndpoint: Endpoint {
    
    public func path() -> String {
        switch self {
        case let .movie(id):
            return "/movie/\(id)"
        }
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }
}
