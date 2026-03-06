import Foundation
import Models
import NetworkClient
import OSLog

struct ListSectionState<T> {
    var fullList: [T]
    var abbreviatedList: [T] {
        Array(fullList.prefix(limiter))
    }

    var showData: Bool {
        !abbreviatedList.isEmpty
    }

    var showMoreVisible: Bool {
        fullList.count > abbreviatedList.count
    }

    init(fullList: [T] = []) {
        self.fullList = fullList
    }

    private let limiter = 3

    mutating func inject(_ newElements: [T]) {
        fullList.append(contentsOf: newElements)
    }
}

@MainActor
@Observable
final class ListDataStore {

    var popularMoviesState: ListSectionState<MovieModel> = .init()
    var popularTvState: ListSectionState<TvModel> = .init()

    private let listNetworkManager: ListNetworkManagerProtocol
    private let logger = Logger(category: "ListDataStore")

    init(listNetworkManager: ListNetworkManagerProtocol) {
        self.listNetworkManager = listNetworkManager
    }

    func fetchPopular() async {
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
}
