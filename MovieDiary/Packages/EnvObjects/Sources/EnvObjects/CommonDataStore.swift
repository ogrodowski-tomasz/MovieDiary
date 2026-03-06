import Foundation
import NetworkClient
import Models
import OSLog

@Observable
@MainActor
public final class CommonDataStore {

    public var configuration: AppConfiguration?

    private let commonNetworkManager: NetworkClient.CommonNetworkManagerProtocol
    
    private let logger = Logger(category: "CommonDataStore")
    
    public init(commonNetworkManager: NetworkClient.CommonNetworkManagerProtocol) {
        self.commonNetworkManager = commonNetworkManager
    }
    
    public func getConfiguration() async {
        do {
            logger.info("Starting to fetch configuration")
            let configuration = try await commonNetworkManager.getAppConfiguration()
            self.configuration = configuration
            logger.info("Successfully fetched configuration")
        } catch {
            logger.error("Error fetching configuration: \(error.localizedDescription)")
        }
    }
}
