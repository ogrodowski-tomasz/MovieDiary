import CoreNetwork

public enum UserEndpoint: Sendable {
    case requestToken
    case currentUser(id: String, sessionID: String)
    case createSession(requestToken: String)
    case userRatedMoviesList(userId: String, sessionId: String, page: Int, language: String)
    case movieAccountState(movieId: Int, sessionId: String)
    case toggleFavoriteMovie(userId: Int, movieId: Int, sessionId: String, newValue: Bool)
    
    public var endpoint: Endpoint {
        switch self {
        case .requestToken:
            return .init(
                path: "/authentication/token/new",
                queryItems: nil
            )
        case let .currentUser(id, sessionID):
            return .init(
                path: "/account/\(id)",
                queryItems: [.sessionId(sessionID)]
            )
        case let .createSession(requestToken):
            return .init(
                path: "/authentication/session/new",
                queryItems: nil,
                jsonValue: [
                    "request_token": requestToken
                ] as JSONBodyCovertible
            )
        case let .userRatedMoviesList(userId, sessionId, page, language):
            return .init(
                path: "/account/\(userId)/rated/movies",
                queryItems: [.sessionId(sessionId), .language(language), .page(page)]
            )
        case let .movieAccountState(movieId, sessionId):
            return .init(
                path: "/movie/\(movieId)/account_states",
                queryItems: [.sessionId(sessionId)]
            )
        case let .toggleFavoriteMovie(userId, movieId, sessionId, newValue):
            return .init(
                path: "/account/\(userId)/favorite",
                queryItems: [.sessionId(sessionId)],
                jsonValue: FavoriteEncodable(
                    media_type: "movie",
                    media_id: movieId,
                    favorite: newValue
                ) as JSONBodyCovertible
            )
        }
    }
    
    private struct FavoriteEncodable: Encodable {
        let media_type: String
        let media_id: Int
        let favorite: Bool
    }
}
