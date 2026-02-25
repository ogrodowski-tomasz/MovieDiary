import Foundation

protocol CommonNetworkManagerProtocol: Sendable {
    func getAppConfiguration() async throws -> AppConfiguration
}

struct CommonNetworkManager: CommonNetworkManagerProtocol {
    
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    func getAppConfiguration() async throws -> AppConfiguration {
        return try await client.get(endpoint: CommonEndpoint.configuration)
    }
}
