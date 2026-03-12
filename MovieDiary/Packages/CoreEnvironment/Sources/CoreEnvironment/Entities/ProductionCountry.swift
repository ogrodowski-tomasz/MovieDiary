import Foundation

public struct ProductionCountry: Codable, Sendable, Hashable {
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
