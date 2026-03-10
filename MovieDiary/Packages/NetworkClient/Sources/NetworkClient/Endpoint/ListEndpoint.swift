import Foundation
import Models

public enum ListEndpoint {
    case popular(type: ListType, page: Int)
    case topRated(type: ListType, page: Int)

    case moviesUpcoming(page: Int)

    case tvShowsAiringToday(page: Int)
}

extension ListEndpoint: Endpoint {

    public func path() -> String {
        switch self {
        case let .popular(type, _):
            return "/\(type.endpointPathComponent)/popular"
        case let .topRated(type, _):
            return "/\(type.endpointPathComponent)/top_rated"
        case .moviesUpcoming:
            return "/movie/upcoming"
        case .tvShowsAiringToday:
            return "/tv/airing_today"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case let .popular(_, page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case let .topRated(_, page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case let .moviesUpcoming(page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case let .tvShowsAiringToday(page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }

}
