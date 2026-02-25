import Foundation

struct AppConfiguration: Codable {
    let changeKeys: [String]
    let images: Images

    enum CodingKeys: String, CodingKey {
        case changeKeys = "change_keys"
        case images
    }
}

struct Images: Codable {
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes, logoSizes, posterSizes, profileSizes: [String]
    let stillSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
    
    func profileMainPosterSize() -> String? {
        guard !profileSizes.isEmpty else { return nil }
        guard profileSizes.count > 2 else { return profileSizes.first }
        return profileSizes[3]
    }
    
    func withPath(_ path: String) -> URL? {
        guard let url = URL(string: secureBaseURL), let size = profileMainPosterSize() else { return nil }
        return url.appending(path: "/\(size)/").appending(path: path)
    }
}

