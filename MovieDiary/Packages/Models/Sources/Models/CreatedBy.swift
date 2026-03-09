import Foundation

public struct CreatedBy: Codable, Sendable, Identifiable, Hashable {
    public let id: Int
    public let creditID, name, originalName: String?
    public let gender: Int?
    public let profilePath: String?

    public enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name
        case originalName = "original_name"
        case gender
        case profilePath = "profile_path"
    }

    public init(id: Int, creditID: String?, name: String?, originalName: String?, gender: Int?, profilePath: String?) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.originalName = originalName
        self.gender = gender
        self.profilePath = profilePath
    }
}
