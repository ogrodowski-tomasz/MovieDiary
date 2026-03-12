import Foundation

public struct UserRatedMovieListResponse: Codable, Sendable, Hashable {
    public let page: Int
    public let results: [UserRatedMovieModel]
    public let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

public struct UserRatedMovieModel: Codable, Identifiable, Sendable, Hashable {
    public let adult: Bool
    public let backdropPath: String
    public let genreIDS: [Int]
    public let id: Int
    public let originalLanguage, overview: String
    public let originalTitle: String?
    public let popularity: Double
    public let posterPath, releaseDate, title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount, rating: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case rating
    }
}

public extension UserRatedMovieListResponse {
    @MainActor static let empty: Self = .init(page: 1, results: [
        .init(adult: false, backdropPath: "/dXwXcBGK8LJ6UQVvuWM3qG6m6Co.jpg", genreIDS: [10749, 10402, 18], id: 440298, originalLanguage: "pl", overview: "A man and a woman meet in the ruins of post-war Poland. With vastly different backgrounds and temperaments, they are fatally mismatched and yet drawn to each other.", originalTitle: "Zimna Wojna", popularity: 1.6217, posterPath: "/6rbS8oPIgUMhQgIX8oGVTtlNgLR.jpg", releaseDate: "2018-06-08", title: "Cold Waaar", video: false, voteAverage: 0, voteCount: 0, rating: 0)
    ], totalPages: 1, totalResults: 1)
}
