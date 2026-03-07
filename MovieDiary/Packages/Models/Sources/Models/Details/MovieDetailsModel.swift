import Foundation

public struct MovieDetailsModel: Codable, Sendable, Identifiable {
    public let adult: Bool?
    public let backdropPath: String?
    public let belongsToCollection: BelongsToCollection?
    public let budget: Int?
    public let genres: [Genre]
    public let homepage: String?
    public let id: Int
    public let imdbID: String?
    public let originCountry: [String]?
    public let originalLanguage, originalTitle, overview: String?
    public let popularity: Double?
    public let posterPath: String?
    public let productionCompanies: [ProductionCompany]?
    public let productionCountries: [ProductionCountry]?
    public let releaseDate: String?
    public let revenue: Int?
    public let runtime: Int
    public let spokenLanguages: [SpokenLanguage]?
    public let status, tagline: String?
    public let title: String
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?

    public enum CodingKeys: String, CodingKey {
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

    public init(adult: Bool?, backdropPath: String?, belongsToCollection: BelongsToCollection?, budget: Int?, genres: [Genre], homepage: String?, id: Int, imdbID: String?, originCountry: [String]?, originalLanguage: String?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, productionCompanies: [ProductionCompany]?, productionCountries: [ProductionCountry]?, releaseDate: String?, revenue: Int?, runtime: Int, spokenLanguages: [SpokenLanguage]?, status: String?, tagline: String?, title: String, video: Bool?, voteAverage: Double?, voteCount: Int?) {
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
    public var additionalInfoString: String {
        [releaseYear, runtimeFormatted , rateValue].compactMap { $0 }.joined(separator: " · ")
    }
    
    public var runtimeFormatted: String {
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)h \(minutes)min" : "\(minutes)min"
    }
    
    public var releaseYear: String? {
        guard let releaseDate else { return nil }
        let split = releaseDate.split(separator: "-")
        guard let year = split.first(where: { $0.count == 4 }) else { return nil }
        return String(year)
    }
    
    public var rateValue: String? {
        guard let voteAverage else { return nil }
        let stringVal = String(format: "%.1f", voteAverage)
        return "★\(stringVal)"
    }

    public static let sample = Self.init(
        adult: false,
        backdropPath: "/7Zx3wDG5bBtcfk8lcnCWDOLM4Y4.jpg",
        belongsToCollection: .init(
            id: 1504372,
            name: "Lilo & Stitch (Live-Action) Collection",
            posterPath: "/ircyMQMWf2crlsIykVoBUpeo3B.jpg",
            backdropPath: "/g4uH9acht2dhW2rUCxmzLO1s3Fi.jpg"
        ),
        budget: 100000000,
        genres: [
            .init(id: 10751, name: "Family"),
            .init(id: 878, name: "Science Fiction"),
            .init(id: 35, name: "Comedy")
        ],
        homepage: "https://movies.disney.com/lilo-and-stitch-2025",
        id: 552524,
        imdbID: "tt11655566",
        originCountry: ["US"],
        originalLanguage: "en",
        originalTitle: "Lilo & Stitch",
        overview: "The wildly funny and touching story of a lonely Hawaiian girl and the fugitive alien who helps to mend her broken family.",
        popularity: 33.4137,
        posterPath: "/ckQzKpQJO4ZQDCN5evdpKcfm7Ys.jpg",
        productionCompanies: [
            .init(id: 2, logoPath: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png", name: "Walt Disney Pictures", originCountry: "US"),
            .init(id: 118854, logoPath: "/g9LPNlQFoDcHjfnvrEqFmeIaDrZ.png", name: "Rideback", originCountry: "US")
        ],
        productionCountries: [
            .init(iso3166_1: "US", name: "United States of America")
        ],
        releaseDate: "2025-05-17",
        revenue: 1038027526,
        runtime: 108,
        spokenLanguages: [
            .init(englishName: "English", iso639_1: "en", name: "English")
        ],
        status: "Released",
        tagline: "Hold on to your coconuts.",
        title: "Lilo & Stitch",
        video: false,
        voteAverage: 7.21,
        voteCount: 2052
    )}

// MARK: - BelongsToCollection
public struct BelongsToCollection: Codable, Sendable {
    public let id: Int?
    public let name, posterPath, backdropPath: String?

    public enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }

    public init(id: Int?, name: String?, posterPath: String?, backdropPath: String?) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}

// MARK: - ProductionCountry
public struct ProductionCountry: Codable, Sendable {
    public let iso3166_1, name: String?

    public enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }

    public init(iso3166_1: String?, name: String?) {
        self.iso3166_1 = iso3166_1
        self.name = name
    }
}

// MARK: - SpokenLanguage
public struct SpokenLanguage: Codable, Sendable {
    public let englishName, iso639_1, name: String?

    public enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }

    public init(englishName: String?, iso639_1: String?, name: String?) {
        self.englishName = englishName
        self.iso639_1 = iso639_1
        self.name = name
    }
}
