import Foundation

public struct Season: Codable, Sendable, Identifiable, Hashable {
    public let airDate: String?
    public let episodeCount: Int?
    public let id: Int
    public let name, overview, posterPath: String?
    public let seasonNumber: Int?
    public let voteAverage: Double?

    public enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }

    public init(airDate: String?, episodeCount: Int?, id: Int, name: String?, overview: String?, posterPath: String?, seasonNumber: Int?, voteAverage: Double?) {
        self.airDate = airDate
        self.episodeCount = episodeCount
        self.id = id
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
        self.seasonNumber = seasonNumber
        self.voteAverage = voteAverage
    }
}
