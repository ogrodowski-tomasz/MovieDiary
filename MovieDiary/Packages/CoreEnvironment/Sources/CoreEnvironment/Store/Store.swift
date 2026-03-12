import Foundation
import CoreNetwork

@MainActor
public protocol Store: Sendable {
    func injectClient(_ httpClient: HTTPClientProtocol)
}

public enum StoreError: Sendable, Error {
    case missingClient
}
