import Foundation
import CoreNetwork
import OSLog

public struct AppGenreList {
    public var movieGenres: [Genre]
    public var tvGenres: [Genre]
    
    public init(movieGenres: [Genre], tvGenres: [Genre]) {
        self.movieGenres = movieGenres
        self.tvGenres = tvGenres
    }
}

@MainActor
@Observable
public class CommonDataStore {

    private var client: HTTPClientProtocol?

    public func injectClient(_ httpClient: any HTTPClientProtocol) {
        client = httpClient
    }

    public init() { }

    public var configuration: AppConfiguration?
    public var genres: AppGenreList?
    
    private let logger = Logger(subsystem: "CoreEnvironment", category: "CommonDataStore")
    
    public func getCommonData() async {
        guard let client else { return }
        do {
            logger.info("Starting to fetch configuration")
            let configuration: AppConfiguration = try await client.get(endpoint: CommonEndpoint.configuration.endpoint)
            async let movieGenreList: GenreListModelResponse = try await client.get(endpoint: CommonEndpoint.genres(.movies).endpoint)
            async let tvGenreList: GenreListModelResponse = try await client.get(endpoint: CommonEndpoint.genres(.tvShows).endpoint)
            let genreData = try await (movieGenreList, tvGenreList)
            self.genres = .init(movieGenres: genreData.0.genres, tvGenres: genreData.1.genres)
            self.configuration = configuration
            logger.info("Successfully fetched configuration")
        } catch {
            logger.error("Error fetching configuration: \(error.localizedDescription)")
        }
    }
}
