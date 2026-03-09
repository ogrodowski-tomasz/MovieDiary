import Foundation
import Models

extension DetailsEndpoint: StubEndpoint {

    var stubDataFilename: String? {
        switch self {
        case let .details(type, _):
            switch type {
            case .movies:
                "MovieDetailsStubData"
            case .tvShows:
                "TVDetailsStubData"
            }
        case .recommendations:
            "MovieDetailsRecommendationsStaticData"
        }
    }
}
