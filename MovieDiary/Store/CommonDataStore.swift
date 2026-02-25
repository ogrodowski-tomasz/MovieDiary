import Foundation
import OSLog

@Observable
@MainActor
final class CommonDataStore {
    
    var configuration: AppConfiguration?
    
    private let commonNetworkManager: CommonNetworkManagerProtocol
    
    private let logger = Logger(category: "CommonDataStore")
    
    init(commonNetworkManager: CommonNetworkManagerProtocol) {
        self.commonNetworkManager = commonNetworkManager
    }
    
    func getConfiguration() async {
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
