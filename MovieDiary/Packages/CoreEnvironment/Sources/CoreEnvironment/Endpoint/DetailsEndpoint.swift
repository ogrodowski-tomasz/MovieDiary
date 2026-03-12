import CoreNetwork

public enum DetailsEndpoint: Sendable {
    case details(ListType, id: Int)
    case recommendations(ListType, id: Int, page: Int)
    case credits(ListType, id: Int)
}

extension DetailsEndpoint {
    
    public var endpoint: Endpoint {
        switch self {
        case let .details(listType, id):
            return .init(
                path: "/\(listType.endpointPathComponent)/\(id)"
            )
        case let .recommendations(listType, id, page):
            return .init(
                path: "/\(listType.endpointPathComponent)/\(id)/recommendations",
                queryItems: [.init(name: "page", value: "\(page)")]
            )
        case let .credits(listType, id):
            return .init(
                path: "/\(listType.endpointPathComponent)/\(id)/credits"
            )
        }
    }

}
