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
}

extension ListEndpoint: Endpoint {
    func path() -> String {
        switch self {
        case .popular(let listType):
            return "/\(listType.pathComponent)/popular"
        }
    }
    
    func queryItems() -> [URLQueryItem]? {
        switch self {
        case .popular(let listType):
            return nil
        }
    }

}
