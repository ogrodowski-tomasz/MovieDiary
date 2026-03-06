import Foundation
import SwiftUI

public enum ListType: Hashable, CaseIterable, Sendable {
    case movies
    case tvShows

    public var title: LocalizedStringResource {
        switch self {
        case .movies:
            "Movies"
        case .tvShows:
            "TV Shows"
        }
    }

    public var endpointPathComponent: String {
        switch self {
        case .movies:
            "movie"
        case .tvShows:
            "tv"
        }
    }
}
