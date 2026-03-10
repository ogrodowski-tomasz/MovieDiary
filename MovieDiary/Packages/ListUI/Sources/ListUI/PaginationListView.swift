import SwiftUI
import Models

public struct PaginationListView: View {
    
    @Environment(\.httpClient) var httpClient
    @State private var viewModel: PaginationListViewModel
    
    public init(mode: PaginationListMode) {
        _viewModel = State(initialValue: .init(mode: mode))
    }

    public var body: some View {
        List {
            ForEach(viewModel.models) { model in
                Text(model.title)
            }
            switch viewModel.state {
            case let .display(_ ,nextPageState):
                ProgressView()
                    .task {
                        await nextPage()
                    }
            default:
                EmptyView()
            }
        }
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

//#Preview {
//    PaginationListView()
//}
