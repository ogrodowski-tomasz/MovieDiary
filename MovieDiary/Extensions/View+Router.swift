import DetailsUI
import EnvObjects
import SwiftUI
import Models

extension View {
    func withRouter() -> some View {
        navigationDestination(for: RouteDestination.self) { destination in
            switch destination {
            case let .details(model as MovieModel):
                DetailsView(viewModel: .from(movieModel: model))
            case let .details(model as MovieRecommendationModel):
                DetailsView(viewModel: .from(recommendationModel: model))
            case .showFull:
                Text("SHOW FULL LIST HERE WITH PAGINATION")
            default:
                Text("THIS ROUTE IS NOT SUPPORTED YET \(destination)")
            }
        }
    }
}
