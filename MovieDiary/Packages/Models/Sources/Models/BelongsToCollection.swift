import Foundation

public struct BelongsToCollection: Codable, Sendable, Hashable {
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
