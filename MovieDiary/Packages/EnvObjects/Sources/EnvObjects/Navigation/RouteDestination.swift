import Foundation
import Models

public enum RouteDestination: Hashable {
    case details(id: Int, listType: ListType)
    case showFull
}
