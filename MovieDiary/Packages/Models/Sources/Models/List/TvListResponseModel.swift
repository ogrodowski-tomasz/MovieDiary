import Foundation

public struct TvListResponseModel: Codable, Sendable {
    public let page: Int
    public let results: [TvModel]
    public let totalPages, totalResults: Int

    public enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    public init(page: Int, results: [TvModel], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

public struct TvModel: Codable, Identifiable, Sendable {
    public let adult: Bool?
    public let backdropPath: String?
    public let title: String
    public let posterPath: String
    public let genreIDS: [Int]?
    public let id: Int
    public let originCountry: [String]?
    public let originalLanguage: String?
    public let originalTitle, overview: String?
    public let popularity: Double?
    public let firstAirDate: String?
    public let voteAverage: Double?
    public let voteCount: Int?

    public enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case title = "name"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    public init(adult: Bool, backdropPath: String, genreIDS: [Int], id: Int, originCountry: [String], originalLanguage: String, originalName: String, overview: String, popularity: Double, posterPath: String, firstAirDate: String, name: String, voteAverage: Double, voteCount: Int) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalTitle = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.firstAirDate = firstAirDate
        self.title = name
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
