import Foundation

public struct ListResponseModel: Decodable, Sendable, Hashable {
    public let page: Int
    public let results: [ListModel]
    public let totalPages: Int
    public let totalResults: Int
    
    public enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

public struct ListModel: Decodable, Sendable, Hashable, Identifiable {
    public let id: Int
    public let overview: String
    public let posterPath: String
    public let releaseDate: String
    public let title: String
    
    public let listType: ListType
}

public extension ListModel {
    init(from decoder: Decoder) throws {
        do {
            if let movie = try? MovieSpecificListModel(from: decoder) {
                self.id = movie.id
                self.overview = movie.overview ?? ""
                self.posterPath = movie.poster_path ?? ""
                self.releaseDate = movie.release_date.getYear
                self.title = movie.title
                self.listType = .movies
            } else {
                let tv = try TVSpecificListModel(from: decoder)
                self.id = tv.id
                self.overview = tv.overview ?? ""
                self.posterPath = tv.poster_path ?? ""
                self.releaseDate = tv.first_air_date.getYear
                self.title = tv.name
                self.listType = .tvShows
            }
        } catch {
            throw error
        }
    }
}

public extension ListModel {
    static func sample(_ listType: ListType) -> Self {
        switch listType {
        case .movies:
            return .movieSample
        case .tvShows:
            return .tvSample
        }
    }
    
    private static let movieSample = Self.init(
        id: 228,
        overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
        posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
        releaseDate: "1994-09-23",
        title: "The Shawshank Redemption",
        listType: .movies
    )
    
    private static let tvSample = Self.init(
        id: 1396,
        overview: "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
        posterPath: "/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg",
        releaseDate: "2008-01-20",
        title: "Breaking Bad",
        listType: .tvShows
    )
}
