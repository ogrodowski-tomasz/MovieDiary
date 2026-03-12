import Foundation

public struct DetailsWrapperModel: Decodable, Sendable, Identifiable, Equatable {
    
    public let id: Int
    public let title: String
    public let additionalInfo: [LocalizedStringResource]
    public let genresJoined: String
    
    private var movie: MovieSpecificDetailsModel?
    private var tv: TvSpecificDetailsModel?
    
    public init(from decoder: any Decoder) throws {
        do {
            if let decoded = try? MovieSpecificDetailsModel(from: decoder) {
                self.movie = decoded
                id = decoded.id
                title = decoded.title
                additionalInfo = decoded.additionalInfos
                genresJoined = decoded.genresJoined
            } else {
                let decoded = try TvSpecificDetailsModel(from: decoder)
                id = decoded.id
                title = decoded.name
                additionalInfo = decoded.additionalInfos
                genresJoined = decoded.genresJoined
            }
        } catch {
            throw error
        }
    }
}
