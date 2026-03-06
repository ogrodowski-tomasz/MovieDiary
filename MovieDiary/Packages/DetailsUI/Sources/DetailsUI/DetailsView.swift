import SwiftUI
import Models
import EnvObjects
import NetworkClient

public struct DetailsView: View {
    enum ViewState {
        case loading
        case loaded(MovieDetailsModel)
    }
    let id: Int
    let listType: ListType

    @Environment(\.httpClient) var client
    @State private var viewState: ViewState = .loading

    public init(id: Int, listType: ListType) {
        self.id = id
        self.listType = listType
    }

    public var body: some View {
        Group {
            switch viewState {
            case .loading:
                ProgressView()
            case .loaded(let movieDetailsModel):
                VStack {
                    Text("Title: \(movieDetailsModel.title)")
                    Text("Revenue: \(movieDetailsModel.revenue)")
                    Text("Budget: \(movieDetailsModel.budget ?? -1)")
                }
            }
        }
        .task {
            await fetchDetails()
        }

    }

    private func fetchDetails() async {
        viewState = .loading
        do {
            let details: MovieDetailsModel = try await client.get(endpoint: DetailsEndpoint.movie(id: id))
//            let details = try await detailsNetworkManager.getMovieDetails(id: id)
            viewState = .loaded(details)
        } catch {
            print(error)
        }
    }
}

#Preview {
    DetailsView(id: 123141324123123, listType: .movies)
}
