import Foundation

public struct MovieSpecificListModel: Decodable, Sendable, Hashable, Identifiable {
    public let id: Int
    public let overview: String?
    public let poster_path: String?
    public let release_date: String
    public let title: String
    public let vote_average: Double?
}
