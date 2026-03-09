import DetailsUI
import EnvObjects
import SwiftUI
import Models

extension View {
    func withRouter() -> some View {
        navigationDestination(for: RouteDestination.self) { destination in
            switch destination {
            case .details(let listModel):
                #warning("Improve. DetailsViewModel init should be internal?")
                let vm = DetailsViewModel.from(list: listModel)
                DetailsView(viewModel: vm)
            case .showFull:
                Text(verbatim: "SHOW FULL LIST HERE WITH PAGINATION")
            }
        }
    }
}
