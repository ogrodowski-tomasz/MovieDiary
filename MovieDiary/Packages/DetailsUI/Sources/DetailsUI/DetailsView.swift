import SwiftUI
import ListUI
import Models
import EnvObjects
import NetworkClient
import ReusableComponents
import UIKit

public struct DetailsView: View {
    struct ViewModel {
        let model: MovieDetailsModel
        let recommendations: MovieRecommendationsListResponse
    }
    enum ViewState {
        case loading
        case loaded(ViewModel)
    }
    let id: Int
    let listType: ListType

    @Environment(\.httpClient) var client
    
    @Environment(CommonDataStore.self) var commonDataStore
    
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
            case let .loaded(viewModel):
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        DetailsHeaderView(model: viewModel.model)
                            .resizingOnScroll()
                        VStack(spacing: 10) {
                            HStack {
                                Button {
                                    // Favorite
                                } label: {
                                    Image(systemName: "heart")
                                        .font(.title)
                                        .foregroundStyle(.red)
                                }
                                .clipShape(.circle)
                                .buttonStyle(.glass)
                                
                                Button {
                                    // List
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title)
                                }
                                .clipShape(.circle)
                                .buttonStyle(.glass)
                            }
                            
                            if let overview = viewModel.model.overview {
                                Text(overview)
                                    .lineLimit(2)
                            }
                            Text(viewModel.model.additionalInfoString)
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            CarouselListView(title: "Podobne", items: viewModel.recommendations.results, showMore: false)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 150)
                }
                .scrollIndicators(.hidden)
            }
        }
        .ignoresSafeArea()
        .task {
            await fetchDetails()
        }
    }

    private func fetchDetails() async {
        viewState = .loading
        do {
            let details: MovieDetailsModel = try await client.get(endpoint: DetailsEndpoint.movie(id: id))
            let recommendations: MovieRecommendationsListResponse = try await client.get(endpoint: DetailsEndpoint.recommendations(id: id))
            let viewModel = ViewModel(model: details, recommendations: recommendations)
            viewState = .loaded(viewModel)
        } catch {
            print(error)
        }
    }
}

private struct DetailsPreviewWrapper: View {

    @State private var commonDataStore: CommonDataStore

    init() {
        _commonDataStore = State(initialValue: .init())
        commonDataStore.configuration = .sample
        commonDataStore.genres = .init(movieGenres: GenreListModelResponse.sampleMovies.genres, tvGenres: GenreListModelResponse.sampleTV.genres)
    }

    var body: some View {
        DetailsView(id: 123141324123123, listType: .movies)
            .environment(\.httpClient, MockHTTPClient())
            .environment(commonDataStore)
    }
}

#Preview {
    DetailsPreviewWrapper()
}
