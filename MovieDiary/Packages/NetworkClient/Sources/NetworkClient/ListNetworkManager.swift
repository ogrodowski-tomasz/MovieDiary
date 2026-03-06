import Foundation
import Models

public protocol ListNetworkManagerProtocol: Sendable {
    func getPopularMovies(page: Int) async throws -> MovieListResponseModel
    func getPopularTv(page: Int) async throws -> TvListResponseModel
}

public struct ListNetworkManager: ListNetworkManagerProtocol {

    private let client: HTTPClientProtocol

    public init(client: HTTPClientProtocol) {
        self.client = client
    }

    public func getPopularMovies(page: Int) async throws -> MovieListResponseModel {
        let model: MovieListResponseModel = try await client.get(endpoint: ListEndpoint.popular(.movies(page: page)))
        return model
    }

    public func getPopularTv(page: Int) async throws -> TvListResponseModel {
        let model: TvListResponseModel = try await client.get(endpoint: ListEndpoint.popular(.tvShows(page: page)))
        return model
    }
}
