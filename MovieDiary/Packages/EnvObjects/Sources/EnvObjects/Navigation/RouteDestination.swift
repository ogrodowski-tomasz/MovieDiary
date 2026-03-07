import Foundation
import Models

public enum RouteDestination: Hashable {
    case details(id: Int, posterPath: String?, title: String, overview: String?, listType: ListType)
    case showFull
}
