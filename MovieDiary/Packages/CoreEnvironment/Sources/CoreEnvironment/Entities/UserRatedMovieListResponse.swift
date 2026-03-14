import Foundation

public struct UserRatedMovieListResponse: Decodable, Sendable, Hashable {
    public let page: Int
    public let results: [ListModel]
    public let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
