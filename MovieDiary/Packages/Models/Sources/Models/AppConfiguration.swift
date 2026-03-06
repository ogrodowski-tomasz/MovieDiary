import Foundation

public struct AppConfiguration: Codable, Sendable {
    public let changeKeys: [String]
    public let images: Images

    enum CodingKeys: String, CodingKey {
        case changeKeys = "change_keys"
        case images
    }

    public static let sample = Self.init(
        changeKeys: ["adult", "videos"],
        images: .init(
            baseURL: "http://image.tmdb.org/t/p/",
            secureBaseURL: "https://image.tmdb.org/t/p/",
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )
    )
}

public struct Images: Codable, Sendable {
    public let baseURL: String
    public let secureBaseURL: String
    public let backdropSizes, logoSizes, posterSizes, profileSizes: [String]
    public let stillSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
    
    internal func profileMainPosterSize() -> String? {
        guard !profileSizes.isEmpty else { return nil }
        guard profileSizes.count > 2 else { return profileSizes.first }
        return profileSizes[3]
    }
    
    public func withPath(_ path: String) -> URL? {
        guard let url = URL(string: secureBaseURL), let size = profileMainPosterSize() else { return nil }
        return url.appending(path: "/\(size)/").appending(path: path)
    }

    internal func posterSize() -> String? {
        guard !posterSizes.isEmpty else { return nil }
        guard posterSizes.count > 1 else { return posterSizes.first }
        return posterSizes[1]
    }

    public func poster(for path: String?) -> URL? {
        guard let path else { return nil }
        guard let url = URL(string: secureBaseURL), let size = posterSize() else { return nil }
        return url.appending(path: "/\(size)/").appending(path: path)
    }
}

