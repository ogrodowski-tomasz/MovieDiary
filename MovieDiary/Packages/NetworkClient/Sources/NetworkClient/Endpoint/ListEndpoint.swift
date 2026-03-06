import Foundation

enum ListType {
    case movies(page: Int)
    case tvShows(page: Int)

    var pathComponent: String {
        switch self {
        case .movies:
            "movie"
        case .tvShows:
            "tv"
        }
    }
}

enum ListEndpoint {
    case popular(ListType)
    case topRated(ListType)

    case moviesUpcoming(page: Int)

    case tvShowsAiringToday(page: Int)
}

extension ListEndpoint: Endpoint {
    func path() -> String {
        switch self {
        case .popular(let listType):
            return "/\(listType.pathComponent)/popular"
        case .topRated(let listType):
            return "/\(listType.pathComponent)/top_rated"
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
