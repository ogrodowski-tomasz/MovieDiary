import Foundation

extension CommonEndpoint: StubEndpoint {

    var stubDataFilename: String? {
        switch self {
        case .configuration:
            "AppConfigurationStaticData"
        case .genres:
            "GenreListStaticData"
        }
    }
}
