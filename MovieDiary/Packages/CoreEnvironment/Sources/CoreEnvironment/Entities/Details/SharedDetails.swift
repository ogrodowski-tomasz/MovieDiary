import Foundation

public protocol SharedDetails {
    var additionalInfos: [LocalizedStringResource] { get }
    var genresJoined: String { get }
}
