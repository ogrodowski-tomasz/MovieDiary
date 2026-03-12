import CoreNetwork

public enum DetailsEndpoint: Sendable {
    case details(ListType, id: Int, language: String)
    case recommendations(ListType, id: Int, page: Int, language: String)
    case credits(ListType, id: Int, language: String)
}

extension DetailsEndpoint {
    
    public var endpoint: Endpoint {
        switch self {
        case let .details(listType, id, lang):
            return .init(
                path: "/\(listType.endpointPathComponent)/\(id)",
                queryItems: [.language(lang)]
            )
        case let .recommendations(listType, id, page, lang):
            return .init(
                path: "/\(listType.endpointPathComponent)/\(id)/recommendations",
                queryItems: [.page(page), .language(lang)]
            )
        case let .credits(listType, id, lang):
            return .init(
                path: "/\(listType.endpointPathComponent)/\(id)/credits",
                queryItems: [.language(lang)]
            )
        }
    }

}
