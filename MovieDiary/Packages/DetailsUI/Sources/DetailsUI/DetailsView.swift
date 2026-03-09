import SwiftUI
import ListUI
import Models
import EnvObjects
import NetworkClient
import ReusableComponents
import UIKit

public struct DetailsView: View {
    @State private var viewModel: DetailsViewModel
    
    @Environment(\.httpClient) var client
    
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(UserSessionStore.self) var userSessionStore
        
    public init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    DetailsHeaderView(viewModel: viewModel)
                        .resizingOnScroll()
                    VStack(spacing: 10) {
                        HStack {
                            Button(action: onFavoriteTapped) {
                                Image(systemName: viewModel.favoriteImageName)
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
                        
                        if let overview = viewModel.overview {
                            Text(overview)
                                .lineLimit(2)
                        }
                        
                        AdditionalInfoView(info: viewModel.details?.additionalInfo ?? [], redacted: viewModel.details == nil)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    
//                    VStack(alignment: .leading, spacing: 10) {
//                        if let recommendation = viewModel.recommendations?.results {
//                            CarouselListView(title: "Podobne", items: recommendation, showMore: false)
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .redactWithPlaceholder(when: viewModel.recommendations?.results == nil)
                }
                .padding(.bottom, 150)
            }
            .scrollIndicators(.hidden)
        }
        .backMenuTitle(viewModel.title)
        .ignoresSafeArea()
        .task {
            await fetchAccountState()
            await fetchDetails()
        }
    }
    
    private func fetchDetails() async {
        do {
            let id = viewModel.id
            let listType = viewModel.listType
            let details: DetailsWrapperModel = try await client.get(endpoint: DetailsEndpoint.details(listType, id: id))
            viewModel.inject(details: details)
        } catch {
            print(error)
        }
    }
    
    private func fetchAccountState() async {
        do {
            guard case .movies = viewModel.listType else { return }
            let id = viewModel.id
            let model = try await userSessionStore.getMovieAccountState(id: id)
            viewModel.inject(accountState: model)
        } catch {
            print(error)
        }
    }
    
    private func onFavoriteTapped() {
        guard let accountState = viewModel.accountState else { return }
        Task {
            do {
                let id = viewModel.id
                let newValue = !accountState.favorite
                let updatedMovie = try await userSessionStore.toggleMovieFavorite(id: id, newValue: newValue)
                viewModel.inject(accountState: updatedMovie)
            } catch {
                print(error)
            }
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
        DetailsView(viewModel: .from(list: .sample(.movies)))
            .environment(\.httpClient, MockHTTPClient())
            .environment(commonDataStore)
    }
}

#Preview {
    DetailsPreviewWrapper()
}
