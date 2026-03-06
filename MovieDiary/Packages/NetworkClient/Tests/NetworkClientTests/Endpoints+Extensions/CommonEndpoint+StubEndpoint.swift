import Foundation
@testable import NetworkClient

extension CommonEndpoint: StubEndpoint {

    var stubDataFilename: String? {
        switch self {
        case .configuration:
            "AppConfigurationStaticData"
        }
    }
}
