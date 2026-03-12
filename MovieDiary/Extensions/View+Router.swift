import CoreEnvironment

import FeatureMediaDetails
import FeaturePagination
import FeatureProfile

import SwiftUI

extension View {
    func withRouter() -> some View {
        navigationDestination(for: RouteDestination.self) { destination in
            switch destination {
            case .details(let listModel):
                #warning("Improve. DetailsViewModel init should be internal?")
                let vm = DetailsViewModel.from(list: listModel)
                DetailsView(viewModel: vm)
            case let .paginatedList(mode):
                PaginationListView(mode: mode)
            case let .castList(cast):
                CastListView(cast: cast)
            case let .allLanguages(all, current):
                LanguagesListView(list: all, current: current)
            }
        }
    }
}
