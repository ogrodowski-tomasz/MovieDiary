import Foundation

public struct MovieRecommendationsListResponse: Codable, Sendable {
    public let page: Int
    public let results: [MovieRecommendationModel]
    public let totalPages, totalResults: Int

    public enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    public init(page: Int, results: [MovieRecommendationModel], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

public struct MovieRecommendationModel: Codable, Sendable, Identifiable {
    public let adult: Bool?
    public let backdropPath: String?
    public let id: Int
    public let title: String
    public let posterPath: String
    public let originalTitle, overview: String?
    public let mediaType: MediaType?
    public let originalLanguage: String?
    public let genreIDS: [Int]
    public let popularity: Double?
    public let releaseDate: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?

    public enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    public init(adult: Bool?, backdropPath: String?, id: Int, title: String, originalTitle: String?, overview: String?, posterPath: String, mediaType: MediaType?, originalLanguage: String?, genreIDS: [Int], popularity: Double?, releaseDate: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.mediaType = mediaType
        self.originalLanguage = originalLanguage
        self.genreIDS = genreIDS
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

public enum MediaType: String, Codable, Sendable {
    case movie = "movie"
}
