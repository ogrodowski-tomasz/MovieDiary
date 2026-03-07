import Foundation

extension UserEndpoint: StubEndpoint {

    var stubDataFilename: String? {
        switch self {
        case .currentUser:
            return "TmdbUserStaticData"
        case .userRatedMoviesList:
            return "UserRatedMoviesListStaticData"
        case .requestToken:
            return "RequestTokenStaticData"
        default:
            return nil
        }
    }
}
