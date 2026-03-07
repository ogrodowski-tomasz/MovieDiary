import Foundation

extension DetailsEndpoint: StubEndpoint {

    var stubDataFilename: String? {
        switch self {
        case .movie:
            "MovieDetailsStubData"
        case .recommendations:
            "MovieDetailsRecommendationsStaticData"
        }
    }
}
