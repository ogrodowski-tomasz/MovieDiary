import Foundation
import CoreNetwork

@MainActor
public protocol Store: Sendable {
    func injectClient(_ httpClient: HTTPClientProtocol)
}

public enum StoreError: Sendable, LocalizedError {
    case missingClient
    case missingSessionId
    case missingUser
    
    public var localizedDescription: String {
        switch self {
        case .missingClient:
            return "Missing HTTP client"
        case .missingSessionId:
            return "Missing session ID"
        case .missingUser:
            return "Missing user"
        }
    }
}
