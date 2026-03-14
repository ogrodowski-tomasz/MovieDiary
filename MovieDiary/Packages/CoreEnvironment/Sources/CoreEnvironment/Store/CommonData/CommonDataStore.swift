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
    public var allLanguages: [AppLanguages] = []
    public var genres: AppGenreList?
    
    private let logger = Logger(subsystem: "CoreEnvironment", category: "CommonDataStore")
    
    public func getCommonData(lang: String) async {
        guard let client else { return }
        do {
            logger.info("Starting to fetch configuration")
            let configuration: AppConfiguration = try await client.get(endpoint: CommonEndpoint.configuration.endpoint)
            let allLangauges: [AppLanguages] = try await client.get(endpoint: CommonEndpoint.langauges.endpoint)
            let resultLanguage = allLangauges.resolve(for: lang)
            logger.info("Resolved language: \(resultLanguage.iso_639_1) for id: \(lang)")
            async let movieGenreList: GenreListModelResponse = try await client.get(endpoint: CommonEndpoint.genres(.movies, language: resultLanguage.iso_639_1).endpoint)
            async let tvGenreList: GenreListModelResponse = try await client.get(endpoint: CommonEndpoint.genres(.tvShows, language: resultLanguage.iso_639_1).endpoint)
            let genreData = try await (movieGenreList, tvGenreList)
            self.genres = .init(movieGenres: genreData.0.genres, tvGenres: genreData.1.genres)
            self.configuration = configuration
            self.allLanguages = allLangauges
            logger.info("Successfully fetched configuration")
        } catch let error as HTTPError {
            logger.error("HTTPError fetching configuration: \(error.description)")
        } catch {
            logger.error("Error fetching configuration: \(error.localizedDescription)")
        }
    }
}
