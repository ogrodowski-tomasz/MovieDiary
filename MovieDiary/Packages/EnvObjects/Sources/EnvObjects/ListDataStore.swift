import Foundation
import Models
import NetworkClient
import OSLog

public struct ListSectionState<T> {
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

    init(fullList: [T] = []) {
        self.fullList = fullList
    }

    private let limiter = 6

    mutating func inject(_ newElements: [T]) {
        fullList.append(contentsOf: newElements)
    }
}

@MainActor
@Observable
public final class ListDataStore {

    public var popularMoviesState: ListSectionState<MovieModel> = .init()
    public var popularTvState: ListSectionState<TvModel> = .init()

    public var topRatedMoviesState: ListSectionState<MovieModel> = .init()
    public var topRatedTvState: ListSectionState<TvModel> = .init()

    private let listNetworkManager: ListNetworkManagerProtocol
    private let logger = Logger(category: "ListDataStore")

    public init(listNetworkManager: ListNetworkManagerProtocol) {
        self.listNetworkManager = listNetworkManager
    }

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


    private func fetchPopularMovies() async throws -> [MovieModel] {
        do {
            logger.info("Starting to fetch popular movies")
            let response = try await listNetworkManager.getPopularMovies(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch popular movies: \(error)")
            throw error
        }
    }

    private func fetchPopularTv() async throws -> [TvModel] {
        do {
            logger.info("Starting to fetch popular tv")
            let response = try await listNetworkManager.getPopularTv(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch popular tv shows: \(error)")
            throw error
        }
    }

    private func fetchTopRatedMovies() async throws -> [MovieModel] {
        do {
            logger.info("Starting to fetch top rated movies")
            let response = try await listNetworkManager.getTopRatedMovies(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch top rated movies: \(error)")
            throw error
        }
    }

    private func fetchTopRatedTv() async throws -> [TvModel] {
        do {
            logger.info("Starting to fetch top rated tv")
            let response = try await listNetworkManager.getTopRatedTv(page: 1)
            return response.results
        } catch {
            logger.error("Failed to fetch top rated tv shows: \(error)")
            throw error
        }
    }
}
