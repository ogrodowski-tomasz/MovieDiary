import Foundation

public enum AppEnvironment: Sendable {
    case prod
    
    public var host: String {
        switch self {
        case .prod:
            return "api.themoviedb.org"
        }
    }
}
