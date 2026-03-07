import Foundation

public struct MovieListResponseModel: Codable, Sendable, Hashable {
    public let page: Int
    public let results: [MovieModel]
    public let totalPages, totalResults: Int

    public enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    public init(page: Int, results: [MovieModel], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

public struct MovieModel: Codable, Identifiable, Sendable, Hashable {
    public let adult: Bool
    public let backdropPath: String?
    public let genreIDS: [Int]
    public let id: Int
    public let originalLanguage: String?
    public let originalTitle: String?
    public let overview: String
    public let popularity: Double
    public let posterPath: String
    public let releaseDate: String
    public let title: String

    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int

    public enum CodingKeys: String, CodingKey {
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
    }

    public init(adult: Bool, backdropPath: String?, genreIDS: [Int], id: Int, originalLanguage: String, originalTitle: String, overview: String, popularity: Double, posterPath: String, releaseDate: String, title: String, video: Bool, voteAverage: Double, voteCount: Int) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

    public static let sample = Self.init(
        adult: false,
        backdropPath: "/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg",
        genreIDS: [18, 80],
        id: Int.random(in: 1...1000),
        originalLanguage: "en",
        originalTitle: "The Shawshank Redemption",
        overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
        popularity: 37.0399,
        posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
        releaseDate: "1994-09-23",
        title: "The Shawshank Redemption",
        video: false,
        voteAverage: 8.7,
        voteCount: 29860
    )

    public static let sampleList: [Self] = Array(repeating: .sample, count: 10)
}
