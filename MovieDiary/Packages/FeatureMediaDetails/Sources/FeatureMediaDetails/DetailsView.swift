import SwiftUI
import CoreEnvironment
import CoreNetwork
import CoreDesign
import UIKit

public struct DetailsView: View {
    @State private var viewModel: DetailsViewModel
    
    @Environment(\.httpClient) var client
    
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(UserPreferences.self) var userPreferences
    @Environment(UserSessionStore.self) var userSessionStore
    
    @State private var blockButtons: Bool = false
        
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
                        HStack(spacing: 0) {
                            Button(action: onFavoriteTapped) {
                                Image(systemName: viewModel.favoriteImageName)
                                    .font(.title)
                                    .foregroundStyle(.red)
                                    .frame(width: 50, height: 50)
                                    .clipShape(.rect)
                            }
                            .buttonStyle(.glass)
                            
                            Button(action: onWatchlistTapped) {
                                Image(systemName: viewModel.watchlistImageName)
                                    .font(.title)
                                    .foregroundStyle(viewModel.watchlistColor)
                                    .frame(width: 50, height: 50)
                                    .clipShape(.rect)
                            }
                            .buttonStyle(.glass)
                            
                            Button {
                                // List
                            } label: {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .frame(width: 50, height: 50)
                                    .clipShape(.rect)
                            }
                            .buttonStyle(.glass)

                        }
                        .disabled(blockButtons)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        if let overview = viewModel.overview {
                            Text(overview)
                                .lineLimit(2)
                        }
                        
                        AdditionalInfoView(info: viewModel.details?.additionalInfo ?? [], redacted: viewModel.details == nil)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if let cast = viewModel.cast {
                            CarouselListView(config: .castList(cast, limiter: 5))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .redactWithPlaceholder(when: viewModel.credits == nil)

                    
                    VStack(alignment: .leading, spacing: 10) {
                        if let recommendation = viewModel.recommendations {
                            CarouselListView(config: .paginableList(.recommendations(type: viewModel.listType, id: viewModel.id, initial: recommendation)))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .redactWithPlaceholder(when: viewModel.recommendations == nil)
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
            let lang = userPreferences.appLanguage
            let id = viewModel.id
            let listType = viewModel.listType
            async let details: DetailsWrapperModel = try await client.get(endpoint: DetailsEndpoint.details(listType, id: id, language: lang).endpoint)
            async let recommendation: ListResponseModel = try await client.get(endpoint: DetailsEndpoint.recommendations(listType, id: id, page: 1, language: lang).endpoint)
            async let credits: CreditsResponseModel = try await client.get(endpoint: DetailsEndpoint.credits(listType, id: id, language: lang).endpoint)

            let data = try await (details, recommendation, credits)
            viewModel.inject(details: data.0, recommendations: data.1, credits: data.2)
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
        blockButtons = true
        defer { blockButtons = false }
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
    
    private func onWatchlistTapped() {
        guard let accountState = viewModel.accountState else { return }
        blockButtons = true
        defer { blockButtons = false }
        Task {
            do {
                let id = viewModel.id
                let newValue = !accountState.watchlist
                let updatedMovie = try await userSessionStore.toggleMovieWatchlist(id: id, newValue: newValue)
                viewModel.inject(accountState: updatedMovie)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    DetailsView(viewModel: .from(list: .sample))
        .previewEnvironment()
}
