import Foundation
import Models

public enum RouteDestination: Hashable, CustomDebugStringConvertible, Sendable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
    public static func == (lhs: RouteDestination, rhs: RouteDestination) -> Bool {
        switch (lhs, rhs) {
        case let (.details(lhsModel), .details(rhsModel)):
            return lhsModel.id == rhsModel.id
        default:
            return lhs == rhs
        }
    }
    
    case details(any CarouselModel)
    case showFull
    
    public var debugDescription: String {
        switch self {
        case .details(let carouselModel):
            "Details (\(carouselModel.title))"
        case .showFull:
            "Show Full"
        }
    }

}
