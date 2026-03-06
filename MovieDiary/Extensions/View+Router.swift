import DetailsUI
import EnvObjects
import SwiftUI

extension View {
    func withRouter() -> some View {
        navigationDestination(for: RouteDestination.self) { destination in
            switch destination {
            case let .details(id, type):
                DetailsView(id: id, listType: type)
            case .showFull:
                Text("SHOW FULL LIST HERE WITH PAGINATION")
            }
        }
    }
}
