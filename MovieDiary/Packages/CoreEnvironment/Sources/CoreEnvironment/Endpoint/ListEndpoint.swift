import CoreEnvironment
import CoreNetwork

public enum ListEndpoint {
    case popular(type: ListType, page: Int)
    case topRated(type: ListType, page: Int)
    case moviesUpcoming(page: Int)
    case tvShowsAiringToday(page: Int)
}

extension ListEndpoint {
    
    public var endpoint: Endpoint {
        switch self {
        case .popular(let type, let page):
            return .init(path: "/\(type.endpointPathComponent)/popular", queryItems: [.init(name: "page", value: "\(page)")])
        case .topRated(let type, let page):
            return .init(path: "/\(type.endpointPathComponent)/top_rated", queryItems: [.init(name: "page", value: "\(page)")])
        case .moviesUpcoming(let page):
            return .init(path: "/movie/upcoming", queryItems: [.init(name: "page", value: "\(page)")])
        case .tvShowsAiringToday(let page):
            return .init(path: "/tv/airing_today", queryItems: [.init(name: "page", value: "\(page)")])
        }
    }
}
