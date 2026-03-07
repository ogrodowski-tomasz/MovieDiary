import Foundation

public protocol CarouselModel: Hashable, Equatable, Identifiable, Sendable {
    var posterPath: String { get }
    var title: String { get }
    var id: Int { get }
    var listType: ListType { get }
}

extension MovieModel: CarouselModel {
    public var listType: ListType { .movies }
}

extension TvModel: CarouselModel {
    public var listType: ListType { .tvShows }
}

extension MovieRecommendationModel: CarouselModel {
    
    public var listType: ListType { .movies }
}
