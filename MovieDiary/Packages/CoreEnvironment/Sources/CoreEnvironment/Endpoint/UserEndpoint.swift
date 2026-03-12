import CoreNetwork

public enum UserEndpoint: Sendable {
    case requestToken
    case currentUser(sessionID: String)
    case createSession(requestToken: String)
    case userRatedMoviesList(sessionId: String)
    case movieAccountState(movieId: Int, sessionId: String)
    case toggleFavoriteMovie(movieId: Int, sessionId: String, newValue: Bool)
    
    public var endpoint: Endpoint {
        switch self {
        case .requestToken:
            return .init(
                path: "/authentication/token/new",
                queryItems: nil
            )
        case .currentUser(let sessionID):
            return .init(
                path: "/account/12719379",
                queryItems: [.init(
                    name: "session_id",
                    value: sessionID
                )]
            )
        case .createSession(let requestToken):
            return .init(
                path: "/authentication/session/new",
                queryItems: nil,
                jsonValue: [
                    "request_token": requestToken
                ] as JSONBodyCovertible
            )
        case .userRatedMoviesList(let sessionId):
            return .init(
                path: "/account/12719379/rated/movies",
                queryItems: [.init(
                    name: "session_id",
                    value: sessionId
                )]
            )
        case .movieAccountState(let movieId, let sessionId):
            return .init(
                path: "/movie/\(movieId)/account_states",
                queryItems: [.init(
                    name: "session_id",
                    value: sessionId
                )]
            )
        case .toggleFavoriteMovie(let movieId, let sessionId, let newValue):
            return .init(
                path: "/account/12719379/favorite",
                queryItems: [.init(name: "session_id", value: sessionId)],
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
