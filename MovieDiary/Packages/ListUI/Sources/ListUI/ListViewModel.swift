import Foundation
import Models
import NetworkClient
import EnvObjects
import OSLog

struct ListViewState {
    public var moviesSections: [PaginationListMode] {
        [popularMoviesState, upcomingMoviesState, topRatedMoviesState]
            .compactMap { $0 }
    }

    private var popularMoviesState: PaginationListMode?
    private var topRatedMoviesState: PaginationListMode?
    private var upcomingMoviesState: PaginationListMode?

    // MARK: - TV SHOWS

    public var tvShowsSections: [PaginationListMode] {
        [popularTvState, topRatedTvState, airingTodayTvState]
            .compactMap { $0 }
    }

    private var popularTvState: PaginationListMode?
    private var topRatedTvState: PaginationListMode?
    private var airingTodayTvState: PaginationListMode?

    
    mutating func inject(popularMovies: PaginationListMode, topRatedMovies: PaginationListMode, upcomingMovies: PaginationListMode, popularTv: PaginationListMode, topRatedTv: PaginationListMode, airingTodayTv: PaginationListMode) {
        self.airingTodayTvState = airingTodayTv
        self.upcomingMoviesState = upcomingMovies
        self.popularMoviesState = popularMovies
        self.popularTvState = popularTv
        self.topRatedMoviesState = topRatedMovies
        self.topRatedTvState = topRatedTv
    }
}

@MainActor
@Observable
public final class ListViewModel {

    private var client: HTTPClientProtocol?

    public func injectClient(_ httpClient: any NetworkClient.HTTPClientProtocol) {
        client = httpClient
    }
    
    var viewState: ListViewState = .init()

    init() { }

    // MARK: - MOVIES

    private let logger = Logger(category: "ListViewModel")
    
    public func fetchData() async {
        do {
            let page = 1
            async let popularMovies = try await getPopularMovies(page: page)
            async let topRatedMovies = try await getTopRatedMovies(page: page)
            async let upcomingMovies = try await getUpcomingMovies(page: page)
            async let popularTv = try await getPopularTv(page: page)
            async let topRatedTv = try await getTopRatedTv(page: page)
            async let airingTodayTv = try await getAiringTodayTv(page: page)
            let data = try await (popularMovies, topRatedMovies, upcomingMovies, popularTv, topRatedTv, airingTodayTv)
            viewState.inject(
                popularMovies: .popular(type: .movies, initial: data.0),
                topRatedMovies: .topRated(type: .movies, initial: data.1),
                upcomingMovies: .upcoming(initial: data.2),
                popularTv: .popular(type: .tvShows,initial: data.3),
                topRatedTv: .topRated(type: .tvShows, initial: data.4),
                airingTodayTv: .airingToday(initial: data.5)
            )
        } catch {
            logger.error("Error fetching list data: \(error)")
        }
    }

    private func getPopularMovies(page: Int) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: ListResponseModel = try await client.get(endpoint: ListEndpoint.popular(type: .movies, page: page))
        return model
    }

    private func getPopularTv(page: Int) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: ListResponseModel = try await client.get(endpoint: ListEndpoint.popular(type: .tvShows, page: page))
        return model
    }

    // MARK: - TOP RATED

    private func getTopRatedMovies(page: Int) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: ListResponseModel = try await client.get(endpoint: ListEndpoint.topRated(type: .movies, page: page))
        return model
    }

    private func getTopRatedTv(page: Int) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: ListResponseModel = try await client.get(endpoint: ListEndpoint.topRated(type: .tvShows, page: page))
        return model
    }

    // MARK: MOVIES

    private func getUpcomingMovies(page: Int) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: ListResponseModel = try await client.get(endpoint: ListEndpoint.moviesUpcoming(page: page))
        return model
    }

    // MARK: - TV SHOWS

    private func getAiringTodayTv(page: Int) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: ListResponseModel = try await client.get(endpoint: ListEndpoint.tvShowsAiringToday(page: page))
        return model
    }

}
