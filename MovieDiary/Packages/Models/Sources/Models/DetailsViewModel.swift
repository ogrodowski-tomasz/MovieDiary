import Foundation

public struct DetailsViewModel: Sendable, Equatable {
    
    public let id: Int
    public let posterPath: String?
    public let title: String
    public let overview: String?
    public let listType: ListType
    
    public private(set) var favoriteImageName: String = "heart"
    
    public private(set) var genres: String?
    public private(set) var recommendations: [ListModel]?
    public private(set) var details: DetailsWrapperModel?
    public private(set) var credits: CreditsResponseModel?
    public private(set) var accountState: MovieAccountStateModel?
    
    public var cast: [CastCrewModel]? {
        guard let credits, !credits.cast.isEmpty else { return nil }
        return credits.cast
    }
    
    public init(id: Int, posterPath: String?, title: String, overview: String?, listType: ListType, genres: String? = nil, recommendations: [ListModel]? = nil, details: DetailsWrapperModel? = nil, accountState: MovieAccountStateModel? = nil) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
        self.listType = listType
        self.genres = genres
        self.recommendations = recommendations
        self.details = details
        self.accountState = accountState
    }
    
    public static func from(list: ListModel) -> Self {
        return .init(id: list.id, posterPath: list.posterPath, title: list.title, overview: list.overview, listType: list.listType)
    }
    
    public mutating func inject(details: DetailsWrapperModel, recommendations: [ListModel], credits: CreditsResponseModel) {
        self.details = details
        if !recommendations.isEmpty {
            self.recommendations = recommendations
        }
        self.credits = credits
        self.genres = details.genresJoined
    }
    
    
    public mutating func inject(accountState: MovieAccountStateModel) {
        self.accountState = accountState
        favoriteImageName = accountState.favorite ? "heart.fill" : "heart"
    }
}
