import Foundation
import Models

public struct DetailsViewModel: Sendable {
    public let id: Int
    public let posterPath: String?
    public let title: String
    public let overview: String?
    public let listType: ListType
    
    public private(set) var favoriteImageName: String = "heart"
    
    public private(set) var genres: String?
    public private(set) var recommendations: MovieRecommendationsListResponse?
    public private(set) var details: MovieDetailsModel?
    public private(set) var accountState: MovieAccountStateModel?
    
    public init(id: Int, posterPath: String?, title: String, overview: String?, listType: ListType, genres: String? = nil, recommendations: MovieRecommendationsListResponse? = nil, details: MovieDetailsModel? = nil, accountState: MovieAccountStateModel? = nil) {
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
    
    public static func from(movieModel: MovieModel) -> Self {
        return .init(id: movieModel.id, posterPath: movieModel.posterPath, title: movieModel.title, overview: movieModel.overview, listType: .movies)
    }
    
    mutating
    func inject(recommendations: MovieRecommendationsListResponse, details: MovieDetailsModel) {
        self.recommendations = recommendations
        self.details = details
        self.genres = details.genres.join()
    }
    
    mutating
    func inject(accountState: MovieAccountStateModel) {
        self.accountState = accountState
        favoriteImageName = accountState.favorite ? "heart.fill" : "heart"
    }
}
