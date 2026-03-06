import Foundation

public struct AppConfiguration: Codable {
    public let changeKeys: [String]
    public let images: Images

    enum CodingKeys: String, CodingKey {
        case changeKeys = "change_keys"
        case images
    }
}

public struct Images: Codable {
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
    
    public func profileMainPosterSize() -> String? {
        guard !profileSizes.isEmpty else { return nil }
        guard profileSizes.count > 2 else { return profileSizes.first }
        return profileSizes[3]
    }
    
    public func withPath(_ path: String) -> URL? {
        guard let url = URL(string: secureBaseURL), let size = profileMainPosterSize() else { return nil }
        return url.appending(path: "/\(size)/").appending(path: path)
    }
}

