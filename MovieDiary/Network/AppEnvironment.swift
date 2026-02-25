import Foundation

enum AppEnvironment {
    case prod
    
    var host: String {
        switch self {
        case .prod:
            return "api.themoviedb.org"
        }
    }
}
