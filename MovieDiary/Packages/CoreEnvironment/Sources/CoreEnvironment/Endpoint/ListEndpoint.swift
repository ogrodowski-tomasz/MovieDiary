import CoreNetwork

public enum ListEndpoint {
    case popular(type: ListType, page: Int, language: String)
    case topRated(type: ListType, page: Int, language: String)
    case moviesUpcoming(page: Int, language: String)
    case tvShowsAiringToday(page: Int, language: String)
}

extension ListEndpoint {
    
    public var endpoint: Endpoint {
        switch self {
        case let .popular(type, page, lang):
            return .init(
                path: "/\(type.endpointPathComponent)/popular",
                queryItems: [.page(page), .language(lang)]
            )
        case let .topRated(type, page, lang):
            return .init(
                path: "/\(type.endpointPathComponent)/top_rated",
                queryItems: [.page(page), .language(lang)]
            )
        case let .moviesUpcoming(page, lang):
            return .init(
                path: "/movie/upcoming",
                queryItems: [.page(page), .language(lang)]
            )
        case let .tvShowsAiringToday(page, lang):
            return .init(
                path: "/tv/airing_today",
                queryItems: [.page(page), .language(lang)]
            )
        }
    }
}
