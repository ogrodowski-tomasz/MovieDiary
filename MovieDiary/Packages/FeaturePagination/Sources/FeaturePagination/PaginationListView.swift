import CoreDesign
import CoreEnvironment
import SwiftUI
import UIKit

public struct PaginationListView: View {
    
    @Environment(\.httpClient) var httpClient
    @State private var viewModel: PaginationListViewModel
    
    public init(mode: PaginationListMode) {
        _viewModel = State(initialValue: .init(mode: mode))
    }

    public var body: some View {
        List {
            switch viewModel.state {
            case let .display(models, nextPageState):
                Section {
                    ForEach(models) { model in
                        PaginationListCell(model: model)
                    }
                }.listSectionMargins(.top, 0)
                switch nextPageState {
                case .hasNextPage:
                    ProgressView()
                        .task {
                            await nextPage()
                        }
                case .none:
                    Text("🎉 " + "\(String(localized: "pagination.end.label"))")
                        .listRowBackground(Color(uiColor: .systemBackground))
                        .listRowSeparator(.hidden)
                }
            case .loading:
                ProgressView("pagination.loading.label")
            case let .error(error):
                Text(error.localizedDescription)
            }
        }
        .listStyle(.grouped)
        .listSectionSpacing(0)
        .navigationTitle(viewModel.mode.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.inject(httpClient: httpClient)
        }
    }
    
    private func nextPage() async {
        do {
            try await viewModel.fetchNextPage()
        } catch {
            print("DEBUG: Error fetching next page \(error)")
        }
    }
}

struct PaginationListCell: View {
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(Router.self) var router
    let model: ListModel
    
    var img: URL? {
        commonDataStore.configuration?.images.poster(for: model.posterPath)
    }
    
    var body: some View {
        Button {
            router.push(to: .details(model))
        } label: {
            HStack(alignment: .center, spacing: 10) {
                PosterImageView(config: .init(url: img, width: 80, height: 120, cornerRadius: 8))
                VStack(alignment: .leading, spacing: 7) {
                    Text(model.title + " (\(model.releaseDate))")
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(model.overview)
                        .lineLimit(2)
                    Text("⭐️\(String(format: "%.1f", model.voteAverage ?? 0))")
                }
            }
        }
        .buttonStyle(.plain)
        .listRowBackground(Color(uiColor: .systemBackground))
        .listRowSeparator(.visible, edges: [.top])
    }
}

private struct PaginationListPreviewWrapper: View {
    
    @State private var commonDataStore: CommonDataStore
    
    init() {
        _commonDataStore = State(initialValue: .init())
        commonDataStore.configuration = .sample
    }
    
    var body: some View {
        NavigationStack {
            PaginationListView(mode: .topRated(type: .movies, initial: .sample))
        }
            .environment(commonDataStore)
            .environment(Router())
    }
}

#Preview {
    PaginationListPreviewWrapper()
}
