import Foundation

public struct TVSpecificListModel: Decodable, Sendable, Hashable, Identifiable {
    public let id: Int
    public let overview: String?
    public let poster_path: String?
    public let first_air_date: String
    public let name: String
    public let vote_average: Double?
}
