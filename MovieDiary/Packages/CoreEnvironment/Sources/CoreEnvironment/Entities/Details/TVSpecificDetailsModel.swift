import Foundation

public struct TvSpecificDetailsModel: Codable, Sendable, Identifiable, Hashable {
    public let adult: Bool?
    public let backdropPath: String?
    public let createdBy: [CreatedBy]?
    public let episodeRunTime: [Int]?
    public let firstAirDate: String?
    public let genres: [Genre]
    public let homepage: String?
    public let id: Int
    public let inProduction: Bool?
    public let languages: [String]?
    public let lastAirDate: String?
    public let lastEpisodeToAir: EpisodeToAir?
    public let name: String
    public let overview: String
    public let nextEpisodeToAir: EpisodeToAir?
    public let networks: [Network]?
    public let numberOfEpisodes, numberOfSeasons: Int?
    public let originCountry: [String]?
    public let originalLanguage, originalName: String?
    public let popularity: Double?
    public let posterPath: String?
    public let productionCompanies: [Network]?
    public let productionCountries: [ProductionCountry]?
    public let seasons: [Season]
    public let spokenLanguages: [SpokenLanguage]?
    public let status, tagline, type: String?
    public let voteAverage: Double?
    public let voteCount: Int?
}

extension TvSpecificDetailsModel: SharedDetails {

    public var genresJoined: String {
        genres.join()
    }
    
    public var additionalInfos: [LocalizedStringResource] {
        [airingFrame, seasonCount , rateValue].compactMap { $0 }//.joined(separator: " · ")
    }
    
    public var airingFrame: LocalizedStringResource? {
        guard let firstAirDate else { return nil }
        var result = firstAirDate.getYear
        if let lastAirDate {
            result.append("-\(lastAirDate.getYear)")
        }
        return "\(result)"
    }
    
    public var seasonCount: LocalizedStringResource {
        return "\(seasons.count) seasons"
    }
    
    public var rateValue: LocalizedStringResource? {
        guard let voteAverage else { return nil }
        let stringVal = String(format: "%.1f", voteAverage)
        return "★\(stringVal)"
    }

}

public extension TvSpecificDetailsModel {
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(
        adult: Bool?,
        backdropPath: String?,
        createdBy: [CreatedBy]?,
        episodeRunTime: [Int]?,
        firstAirDate: String?,
        genres: [Genre],
        homepage: String?,
        id: Int,
        inProduction: Bool?,
        languages: [String]?,
        lastAirDate: String?,
        lastEpisodeToAir: EpisodeToAir?,
        name: String,
        nextEpisodeToAir: EpisodeToAir?,
        networks: [Network]?,
        numberOfEpisodes: Int?,
        numberOfSeasons: Int?,
        originCountry: [String]?,
        originalLanguage: String?,
        originalName: String?,
        overview: String,
        popularity: Double?,
        posterPath: String?,
        productionCompanies: [Network]?,
        productionCountries: [ProductionCountry]?,
        seasons: [Season],
        spokenLanguages: [SpokenLanguage]?,
        status: String?,
        tagline: String?,
        type: String?,
        voteAverage: Double?,
        voteCount: Int?
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.createdBy = createdBy
        self.episodeRunTime = episodeRunTime
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.inProduction = inProduction
        self.languages = languages
        self.lastAirDate = lastAirDate
        self.lastEpisodeToAir = lastEpisodeToAir
        self.name = name
        self.nextEpisodeToAir = nextEpisodeToAir
        self.networks = networks
        self.numberOfEpisodes = numberOfEpisodes
        self.numberOfSeasons = numberOfSeasons
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.seasons = seasons
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.type = type
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
