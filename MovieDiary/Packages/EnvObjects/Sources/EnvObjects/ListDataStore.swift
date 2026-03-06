import Foundation
import Models
import NetworkClient
import OSLog

public struct ListSectionState<T>: Identifiable {
    public let id: UUID

    public let title: LocalizedStringResource

    var fullList: [T]
    public var abbreviatedList: [T] {
        Array(fullList.prefix(limiter))
    }

    public var showData: Bool {
        !abbreviatedList.isEmpty
    }

    public var showMoreVisible: Bool {
        fullList.count > abbreviatedList.count
    }

    init(_ title: LocalizedStringResource, fullList: [T] = []) {
        self.id = UUID()
        self.title = title
        self.fullList = fullList
    }

    private let limiter = 6

    mutating func inject(_ newElements: [T]) {
        fullList.append(contentsOf: newElements)
    }
}

@MainActor
@Observable
public final class ListDataStore: Store {

    private var client: HTTPClientProtocol?

    public func injectClient(_ httpClient: any NetworkClient.HTTPClientProtocol) {
        client = httpClient
    }

    public init() { }

    // MARK: - MOVIES

    public var moviesSections: [ListSectionState<MovieModel>] {
        [popularMoviesState, upcomingMoviesState, topRatedMoviesState]
    }

    private var popularMoviesState: ListSectionState<MovieModel> = .init("Popular")
    private var topRatedMoviesState: ListSectionState<MovieModel> = .init("Top Rated")
    private var upcomingMoviesState: ListSectionState<MovieModel> = .init("Upcoming")

    // MARK: - TV SHOWS

    public var tvShowsSections: [ListSectionState<TvModel>] {
        [popularTvState, topRatedTvState, airingTodayTvState]
    }

    private var popularTvState: ListSectionState<TvModel> = .init("Popular")
    private var topRatedTvState: ListSectionState<TvModel> = .init("Top Rated")
    private var airingTodayTvState: ListSectionState<TvModel> = .init("Airing Today")

    private let logger = Logger(category: "ListDataStore")

    public func fetchPopular() async {
        do {
            logger.info("Starting to fetch popular")
            async let movies = try await fetchPopularMovies()
            async let tvShows = try await fetchPopularTv()
            let fetched = try await (movies, tvShows)
            popularMoviesState.inject(fetched.0)
            popularTvState.inject(fetched.1)
        } catch {
            logger.error("Failed to fetch popular: \(error)")
        }
    }

    public func fetchTopRated() async {
        do {
            logger.info("Starting to fetch top rated")
            async let movies = try await fetchTopRatedMovies()
            async let tvShows = try await fetchTopRatedTv()
            let fetched = try await (movies, tvShows)
            topRatedMoviesState.inject(fetched.0)
            topRatedTvState.inject(fetched.1)
        } catch {
            logger.error("Failed to fetch top rated: \(error)")
        }
    }

    public func fetchUpcomingMovies() async {
        do {
            logger.info("Starting to fetch upcoming movies")
            let response = try await getUpcomingMovies(page: 1)
            upcomingMoviesState.inject(response.results)
        } catch {
            logger.error("Failed to fetch upcoming movies: \(error)")
        }
    }

    public func fetchAiringTodayTvShows() async {
        do {
            logger.info("Starting to fetch airing today tv")
            let response = try await getAiringTodayTv(page: 1)
            airingTodayTvState.inject(response.results)
        } catch {
            logger.error("Failed to fetch airing today tv shows: \(error)")
        }
    }

    private func fetchPopularMovies() async throws -> [MovieModel] {
        do {
            logger.info("Starting to fetch popular movies")
            let response = try await getPopularMovies(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch popular movies: \(error)")
            throw error
        }
    }

    private func fetchPopularTv() async throws -> [TvModel] {
        do {
            logger.info("Starting to fetch popular tv")
            let response = try await getPopularTv(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch popular tv shows: \(error)")
            throw error
        }
    }

    private func fetchTopRatedMovies() async throws -> [MovieModel] {
        do {
            logger.info("Starting to fetch top rated movies")
            let response = try await getTopRatedMovies(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch top rated movies: \(error)")
            throw error
        }
    }

    private func fetchTopRatedTv() async throws -> [TvModel] {
        do {
            logger.info("Starting to fetch top rated tv")
            let response = try await getTopRatedTv(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch top rated tv shows: \(error)")
            throw error
        }
    }

    public func getPopularMovies(page: Int) async throws -> MovieListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: MovieListResponseModel = try await client.get(endpoint: ListEndpoint.popular(type: .movies, page: page))
        return model
    }

    public func getPopularTv(page: Int) async throws -> TvListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: TvListResponseModel = try await client.get(endpoint: ListEndpoint.popular(type: .tvShows, page: page))
        return model
    }

    // MARK: - TOP RATED

    public func getTopRatedMovies(page: Int) async throws -> MovieListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: MovieListResponseModel = try await client.get(endpoint: ListEndpoint.topRated(type: .movies, page: page))
        return model
    }

    public func getTopRatedTv(page: Int) async throws -> TvListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: TvListResponseModel = try await client.get(endpoint: ListEndpoint.topRated(type: .tvShows, page: page))
        return model
    }

    // MARK: MOVIES

    public func getUpcomingMovies(page: Int) async throws -> MovieListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: MovieListResponseModel = try await client.get(endpoint: ListEndpoint.moviesUpcoming(page: page))
        return model
    }

    // MARK: - TV SHOWS

    public func getAiringTodayTv(page: Int) async throws -> TvListResponseModel {
        guard let client else { throw StoreError.missingClient }
        let model: TvListResponseModel = try await client.get(endpoint: ListEndpoint.tvShowsAiringToday(page: page))
        return model
    }

}
