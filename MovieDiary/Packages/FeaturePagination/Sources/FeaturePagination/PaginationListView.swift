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
