import Foundation
@testable import NetworkClient

extension UserEndpoint: StubEndpoint {

    var stubDataFilename: String? {
        switch self {
        case .currentUser:
            return "TmdbUserStaticData"
        case .userRatedMoviesList:
            return "UserRatedMoviesListStaticData"
        default:
            return nil
        }
    }
}
