import Foundation

public enum CarouselType: Sendable {
    case posters([ListModel])
    case profiles([CastCrewModel])
    
    public var height: CGFloat {
        switch self {
        case .posters: 250
        case .profiles: 200
        }
    }
}
