import Foundation
import NetworkClient
import Models
import OSLog

public struct AppGenreList {
    public var movieGenres: [Genre]
    public var tvGenres: [Genre]
    
    public init(movieGenres: [Genre], tvGenres: [Genre]) {
        self.movieGenres = movieGenres
        self.tvGenres = tvGenres
    }
}

//@MainActor
//public protocol CommonDataStoreProtocol: AnyObject, Store, Observation.Observable {
//    var configuration: AppConfiguration? { get set }
//    var genres: AppGenreList? { get set }
//    func getCommonData() async
//}

@MainActor
@Observable
public class CommonDataStore {

    private var client: HTTPClientProtocol?

    public func injectClient(_ httpClient: any NetworkClient.HTTPClientProtocol) {
        client = httpClient
    }

    public init() { }

    public var configuration: AppConfiguration?
    public var genres: AppGenreList?
    
    private let logger = Logger(category: "CommonDataStore")
    
    public func getCommonData() async {
        guard let client else { return }
        do {
            logger.info("Starting to fetch configuration")
            let configuration: AppConfiguration = try await client.get(endpoint: CommonEndpoint.configuration)
            async let movieGenreList: GenreListModelResponse = try await client.get(endpoint: CommonEndpoint.genres(.movies))
            async let tvGenreList: GenreListModelResponse = try await client.get(endpoint: CommonEndpoint.genres(.tvShows))
            let genreData = try await (movieGenreList, tvGenreList)
            self.genres = .init(movieGenres: genreData.0.genres, tvGenres: genreData.1.genres)
            self.configuration = configuration
            logger.info("Successfully fetched configuration")
        } catch {
            logger.error("Error fetching configuration: \(error.localizedDescription)")
        }
    }
}
