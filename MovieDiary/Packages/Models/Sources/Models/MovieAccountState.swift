import Foundation

public struct MovieAccountStateModel: Codable, Sendable, Hashable {
    public let id: Int
    public let favorite: Bool
    public let rated: Rated?
    public let watchlist: Bool?

    public init(id: Int, favorite: Bool, rated: Rated?, watchlist: Bool?) {
        self.id = id
        self.favorite = favorite
        self.rated = rated
        self.watchlist = watchlist
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.favorite = try container.decode(Bool.self, forKey: .favorite)
        self.rated = try? container.decodeIfPresent(Rated.self, forKey: .rated)
        self.watchlist = try container.decodeIfPresent(Bool.self, forKey: .watchlist)
    }
}

public struct Rated: Codable, Sendable, Hashable {
    public let value: Int?

    public init(value: Int?) {
        self.value = value
    }
}
