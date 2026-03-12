import Foundation

public enum RouteDestination: Hashable, CustomDebugStringConvertible, Sendable {
    case details(ListModel)
    case showFull
    case paginatedList(PaginationListMode)
    
    public var debugDescription: String {
        switch self {
        case .details(let model):
            "Details (\(model.title))"
        case .showFull:
            "Show Full"
        case .paginatedList:
            "Paginated List"
        }
    }

}
