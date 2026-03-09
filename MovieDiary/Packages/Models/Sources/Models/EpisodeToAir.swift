import Foundation

public struct EpisodeToAir: Codable, Sendable, Identifiable, Hashable {
    public let id: Int
    public let name, overview: String?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let airDate: String?
    public let episodeNumber: Int?
    public let episodeType, productionCode: String?
    public let runtime, seasonNumber, showID: Int?
    public let stillPath: String?

    public enum CodingKeys: String, CodingKey {
        case id, name, overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
    }

    public init(id: Int, name: String?, overview: String?, voteAverage: Double?, voteCount: Int?, airDate: String?, episodeNumber: Int?, episodeType: String?, productionCode: String?, runtime: Int?, seasonNumber: Int?, showID: Int?, stillPath: String?) {
        self.id = id
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.episodeType = episodeType
        self.productionCode = productionCode
        self.runtime = runtime
        self.seasonNumber = seasonNumber
        self.showID = showID
        self.stillPath = stillPath
    }
}
