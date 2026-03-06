import Foundation
import NetworkClient
import Models
import OSLog

@Observable
@MainActor
public final class CommonDataStore: Store {

    private var client: HTTPClientProtocol?

    public func injectClient(_ httpClient: any NetworkClient.HTTPClientProtocol) {
        client = httpClient
    }

    public init() { }

    public var configuration: AppConfiguration?
    
    private let logger = Logger(category: "CommonDataStore")
    
    public func getConfiguration() async {
        guard let client else { return }
        do {
            logger.info("Starting to fetch configuration")
            let configuration: AppConfiguration = try await client.get(endpoint: CommonEndpoint.configuration)
            self.configuration = configuration
            logger.info("Successfully fetched configuration")
        } catch {
            logger.error("Error fetching configuration: \(error.localizedDescription)")
        }
    }
}
