import DetailsUI
import EnvObjects
import SwiftUI

extension View {
    func withRouter() -> some View {
        navigationDestination(for: RouteDestination.self) { destination in
            switch destination {
            case let .details(id, posterPath, title, overview, listType):
                DetailsView(viewModel: .init(id: id, posterPath: posterPath, title: title, overview: overview, listType: listType)
                )
            case .showFull:
                Text("SHOW FULL LIST HERE WITH PAGINATION")
            }
        }
    }
}
