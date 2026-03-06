import Foundation
import Models

enum ListEndpoint {
    case popular(type: ListType, page: Int)
    case topRated(type: ListType, page: Int)

    case moviesUpcoming(page: Int)

    case tvShowsAiringToday(page: Int)
}

extension ListEndpoint: Endpoint {
    func path() -> String {
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
    
    func queryItems() -> [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }

}
