import Foundation
import Models
import NetworkClient



@MainActor
@Observable
final class PaginationListViewModel {
    public enum State {
        public enum PagingState {
            case hasNextPage, none
        }
        
        case loading
        case display(
            models: [ListModel],
            nextPageState: PagingState)
        case error(error: Error)
    }
    
    var models: [ListModel]
    var state: State
    
    var mode: PaginationListMode
    var nextPageId: Int?
    
    private var httpClient: HTTPClientProtocol?
    
    init(mode: PaginationListMode) {
        let pagingState: State.PagingState = mode.initial.totalPages > 1 ? .hasNextPage : .none
        models = mode.initial.results
        state = .display(models: mode.initial.results, nextPageState: pagingState)
        self.mode = mode
        nextPageId = pagingState == .hasNextPage ? 2 : nil
    }
    
    internal func inject(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func fetchNextPage() async throws {
        guard let httpClient, let nextPageId else { return }
        let newModels: ListResponseModel
        switch mode {
        case let .topRated(type, _):
            newModels = try await httpClient.get(endpoint: ListEndpoint.topRated(type: type, page: nextPageId))
        case let .popular(type, _):
            newModels = try await httpClient.get(endpoint: ListEndpoint.popular(type: type, page: nextPageId))
        case .upcoming:
            newModels = try await httpClient.get(endpoint: ListEndpoint.moviesUpcoming(page: nextPageId))
        case .airingToday:
            newModels = try await httpClient.get(endpoint: ListEndpoint.tvShowsAiringToday(page: nextPageId))
        }
        
        self.models.append(contentsOf: newModels.results)
        
        let newPagingStatus: State.PagingState = newModels.page < newModels.totalPages ? .hasNextPage : .none
        switch newPagingStatus {
        case .hasNextPage:
            self.nextPageId = nextPageId + 1
        case .none:
            self.nextPageId = nil
        }
        self.state = .display(models: models, nextPageState: newPagingStatus)
    }
}
