import Foundation

enum CommonEndpoint: Endpoint {
    
    case configuration
    
    func path() -> String {
        switch self {
        case .configuration:
            "/configuration"
        }
    }
    
    func queryItems() -> [URLQueryItem]? {
        switch self {
        default: nil
        }
    }
}
