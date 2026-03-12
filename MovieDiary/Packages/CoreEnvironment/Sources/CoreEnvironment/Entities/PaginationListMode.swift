import Foundation

public enum PaginationListMode: Hashable, Sendable {
    case topRated(type: ListType, initial: ListResponseModel)
    case popular(type: ListType, initial: ListResponseModel)
    case upcoming(initial: ListResponseModel)
    case airingToday(initial: ListResponseModel)
    case recommendations(type: ListType, id: Int, initial: ListResponseModel)
    case userRated(userId: String, type: ListType, sessionId: String, initial: ListResponseModel)
    
    public var initial: ListResponseModel {
        switch self {
        case let .topRated(_, initial):
            return initial
        case let .popular(_, initial):
            return initial
        case let .upcoming(initial):
            return initial
        case let .airingToday(initial):
            return initial
        case let .recommendations(_,_,initial):
            return initial
        case let .userRated(_,_, _, initial):
            return initial
        }
    }
    
    public var title: LocalizedStringResource {
        switch self {
        case .topRated:
            "section.title.top.rated"
        case .popular:
            "section.title.popular"
        case .upcoming:
            "section.title.upcoming"
        case .airingToday:
            "section.title.airing.today"
        case .recommendations:
            "section.title.similar"
        case .userRated:
            "section.title.user.rated"
        }
    }
    
    private static let limiter: Int = 5
    
    public var carouselType: CarouselType {
        switch self {
        case let .topRated(_, initial),
            let .popular(_, initial),
            let .upcoming(initial),
            let .airingToday(initial),
            let .recommendations(_,_,initial),
            let .userRated(_,_, _, initial):
            return .posters(Array(initial.results.prefix(Self.limiter)))
        }
    }
    
    public var showMoreActive: Bool {
        switch self {
        case let .topRated(_, initial),
            let .popular(_, initial),
            let .upcoming(initial),
            let .airingToday(initial),
            let .recommendations(_,_,initial):
            return (initial.results.count) > Self.limiter
        default:
            return false
        }
    }
}
