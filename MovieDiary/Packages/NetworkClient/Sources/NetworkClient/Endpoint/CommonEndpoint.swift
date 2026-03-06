import Foundation

public enum CommonEndpoint: Endpoint {

    case configuration
    
    public func path() -> String {
        switch self {
        case .configuration:
            "/configuration"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        default: nil
        }
    }
}
