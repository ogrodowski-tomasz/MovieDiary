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
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case overview = "overview"
        case posterPath = "poster_path"
        
        // Movie specific
        case releaseDate = "release_date"
        case title = "title"
        // Tv specific
        case firstAirDate = "first_air_date"
        case name = "name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        
        if let movieReleaseDate = try? container.decode(String.self, forKey: .releaseDate) {
            self.releaseDate = movieReleaseDate
        } else if let tvReleaseDate = try? container.decode(String.self, forKey: .firstAirDate) {
            self.releaseDate = tvReleaseDate
        } else {
            releaseDate = "#unknownReleaseDate#"
            print("DEBUG: Could not decode release date for id \(id)")
        }
        
        if let movieTitle = try? container.decode(String.self, forKey: .title) {
            self.title = movieTitle
            listType = .movies
        } else if let tvName = try? container.decode(String.self, forKey: .name) {
            self.title = tvName
            listType = .tvShows
        } else {
            title = "#unkownName#"
            listType = .movies
            print("DEBUG: Could not decode title for id \(id)")
        }
    }
    
    public init(id: Int, overview: String, posterPath: String, releaseDate: String, title: String, listType: ListType) {
        self.id = id
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.listType = listType
    }
    
    public static func sample(_ listType: ListType) -> Self {
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
