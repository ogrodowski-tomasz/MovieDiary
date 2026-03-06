import Foundation

public struct TmdbUser: Codable, Sendable {
    public let avatar: Avatar
    public let id: Int
    public let iso639_1, iso3166_1, name: String
    public let includeAdult: Bool
    public let username: String

    enum CodingKeys: String, CodingKey {
        case avatar, id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}

// MARK: - Avatar
public struct Avatar: Codable, Sendable {
    public let gravatar: Gravatar
    public let tmdb: Tmdb
}

// MARK: - Gravatar
public struct Gravatar: Codable, Sendable {
    public let hash: String
}

// MARK: - Tmdb
public struct Tmdb: Codable, Sendable {
    public let avatarPath: String

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
    }
}

public extension TmdbUser {
    @MainActor static let empty: TmdbUser = .init(avatar: .init(gravatar: .init(hash: "3e5575ccb1c22df37fd20a8ae3ed6d48"), tmdb: .init(avatarPath: "/fJ9azA8uhW1FV5ZyVlrhK5DBOis.png")), id: 12719379, iso639_1: "pl", iso3166_1: "PL", name: "Tomasz Ogrodowski", includeAdult: false, username: "tomaszinio")
}
