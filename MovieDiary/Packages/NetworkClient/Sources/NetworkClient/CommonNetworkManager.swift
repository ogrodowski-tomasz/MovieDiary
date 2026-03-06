import Models
import Foundation

public protocol CommonNetworkManagerProtocol: Sendable {
    func getAppConfiguration() async throws -> AppConfiguration
}

public struct CommonNetworkManager: CommonNetworkManagerProtocol {

    private let client: HTTPClientProtocol
    
    public init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    public func getAppConfiguration() async throws -> AppConfiguration {
        return try await client.get(endpoint: CommonEndpoint.configuration)
    }
}
