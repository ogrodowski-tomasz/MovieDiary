import Foundation

public enum HTTPError: Error {
    case invalidRequest(Endpoint)
    case invalidJsonData(Endpoint, Error)
    
    
    public var description: String {
        switch self {
        case .invalidRequest(let endpoint):
            return "Invalid request for \(endpoint.description)"
        case .invalidJsonData(let endpoint, let error):
            return "Failed to decode JSON for \(endpoint.description): \(error.localizedDescription)"
        }
    }
}
