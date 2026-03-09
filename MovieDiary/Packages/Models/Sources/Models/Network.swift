import Foundation

public struct Network: Codable, Sendable, Identifiable, Hashable {
    public let id: Int
    public let logoPath: String?
    public let name, originCountry: String?

    public enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }

    public init(id: Int, logoPath: String?, name: String?, originCountry: String?) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
}
