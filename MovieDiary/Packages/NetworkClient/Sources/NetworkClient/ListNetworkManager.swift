import Foundation
import Models

public protocol ListNetworkManagerProtocol: Sendable {
    func getPopularMovies(page: Int) async throws -> MovieListResponseModel
    func getPopularTv(page: Int) async throws -> TvListResponseModel
    func getTopRatedMovies(page: Int) async throws -> MovieListResponseModel
    func getTopRatedTv(page: Int) async throws -> TvListResponseModel
    func getUpcomingMovies(page: Int) async throws -> MovieListResponseModel
    func getAiringTodayTv(page: Int) async throws -> TvListResponseModel
}

public struct ListNetworkManager: ListNetworkManagerProtocol {

    private let client: HTTPClientProtocol

    public init(client: HTTPClientProtocol) {
        self.client = client
    }

    // MARK: - POPULAR

    public func getPopularMovies(page: Int) async throws -> MovieListResponseModel {
        let model: MovieListResponseModel = try await client.get(endpoint: ListEndpoint.popular(.movies(page: page)))
        return model
    }

    public func getPopularTv(page: Int) async throws -> TvListResponseModel {
        let model: TvListResponseModel = try await client.get(endpoint: ListEndpoint.popular(.tvShows(page: page)))
        return model
    }

    // MARK: - TOP RATED

    public func getTopRatedMovies(page: Int) async throws -> MovieListResponseModel {
        let model: MovieListResponseModel = try await client.get(endpoint: ListEndpoint.topRated(.movies(page: page)))
        return model
    }

    public func getTopRatedTv(page: Int) async throws -> TvListResponseModel {
        let model: TvListResponseModel = try await client.get(endpoint: ListEndpoint.topRated(.tvShows(page: page)))
        return model
    }

    // MARK: MOVIES

    public func getUpcomingMovies(page: Int) async throws -> MovieListResponseModel {
        let model: MovieListResponseModel = try await client.get(endpoint: ListEndpoint.moviesUpcoming(page: page))
        return model
    }

    // MARK: - TV SHOWS

    public func getAiringTodayTv(page: Int) async throws -> TvListResponseModel {
        let model: TvListResponseModel = try await client.get(endpoint: ListEndpoint.tvShowsAiringToday(page: page))
        return model
    }
}
