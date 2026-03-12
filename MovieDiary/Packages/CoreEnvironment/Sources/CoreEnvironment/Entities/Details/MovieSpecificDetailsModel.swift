import Foundation

public struct MovieSpecificDetailsModel: Codable, Sendable, Hashable, Identifiable {
    public let adult: Bool?
    public let backdropPath: String?
    public let belongsToCollection: BelongsToCollection?
    public let budget: Int?
    public let genres: [Genre]
    public let homepage: String?
    public let id: Int
    public let imdbID: String?
    public let originCountry: [String]?
    public let originalLanguage, originalTitle: String?
    public let popularity: Double?
    public let posterPath: String?
    public let productionCompanies: [ProductionCompany]?
    public let productionCountries: [ProductionCountry]?
    public let releaseDate: String?
    public let revenue: Int?
    public let spokenLanguages: [SpokenLanguage]?
    public let status, tagline: String?
    public let title: String
    public let runtime: Int
    public let overview: String
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?
}

extension MovieSpecificDetailsModel: SharedDetails {
    public var genresJoined: String {
        genres.join()
    }
    
    public var additionalInfos: [LocalizedStringResource] {
        [releaseYear, runtimeFormatted , rateValue].compactMap { $0 }//.joined(separator: " · ")
    }
    
    public var runtimeFormatted: LocalizedStringResource {
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)h \(minutes)min" : "\(minutes)min"
    }
    
    public var releaseYear: LocalizedStringResource? {
        guard let releaseDate else { return nil }
        let split = releaseDate.split(separator: "-")
        guard let year = split.first(where: { $0.count == 4 }) else { return nil }
        return "\(year)"
    }
    
    public var rateValue: LocalizedStringResource? {
        guard let voteAverage else { return nil }
        let stringVal = String(format: "%.1f", voteAverage)
        return "★\(stringVal)"
    }
}

public extension MovieSpecificDetailsModel {
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(
        adult: Bool?,
        backdropPath: String?,
        belongsToCollection: BelongsToCollection?,
        budget: Int?,
        genres: [Genre],
        homepage: String?,
        id: Int,
        imdbID: String?,
        originCountry: [String]?,
        originalLanguage: String?,
        originalTitle: String?,
        overview: String,
        popularity: Double?,
        posterPath: String?,
        productionCompanies: [ProductionCompany]?,
        productionCountries: [ProductionCountry]?,
        releaseDate: String?,
        revenue: Int?,
        runtime: Int,
        spokenLanguages: [SpokenLanguage]?,
        status: String?,
        tagline: String?,
        title: String,
        video: Bool?,
        voteAverage: Double?,
        voteCount: Int?
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.belongsToCollection = belongsToCollection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdbID = imdbID
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
