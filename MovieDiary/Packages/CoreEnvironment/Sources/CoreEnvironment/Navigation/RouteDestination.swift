import Foundation

public enum RouteDestination: Hashable, CustomDebugStringConvertible, Sendable {
    case details(ListModel)
    case paginatedList(PaginationListMode)
    case castList([CastCrewModel])
    case allLanguages(all: [AppLanguages], current: String)
    
    public var debugDescription: String {
        switch self {
        case .details(let model):
            "Details (\(model.title))"
        case .paginatedList:
            "Paginated List"
        case .castList:
            "Cast List"
        case .allLanguages:
            "All Languages"
        }
    }

}
