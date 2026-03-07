import Foundation

public enum UserEndpoint: Endpoint {
    case requestToken
    case currentUser(sessionID: String)
    case createSession(requestToken: String)
    case userRatedMoviesList(sessionId: String)
    case movieAccountState(movieId: Int, sessionId: String)
    case toggleFavoriteMovie(movieId: Int, sessionId: String, newValue: Bool)
    
    public func path() -> String {
        switch self {
        case .requestToken:
            "/authentication/token/new"
        case .currentUser:
            "/account/12719379"
        case .createSession:
            "/authentication/session/new"
        case .userRatedMoviesList:
            "/account/12719379/rated/movies"
        case let .movieAccountState(movieId, _):
            "/movie/\(movieId)/account_states"
        case .toggleFavoriteMovie:
            "/account/12719379/favorite"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case .requestToken:
            return nil
        case let .currentUser(sessionID):
            return [.init(name: "session_id", value: sessionID)]
        case .createSession:
            return nil
        case let .userRatedMoviesList(sessionId):
            return [.init(name: "session_id", value: sessionId)]
        case let .movieAccountState(_, sessionId):
            return [.init(name: "session_id", value: sessionId)]
        case let .toggleFavoriteMovie(_, sessionId,_):
            return [.init(name: "session_id", value: sessionId)]

        }
    }
    
    public var jsonValue: Encodable? {
        switch self {
        case let .createSession(requestToken):
            return [
                "request_token": requestToken
            ] as Encodable
        case let .toggleFavoriteMovie(movieId,_, newValue):
            return FavoriteEncodable(media_type: "movie", media_id: movieId, favorite: newValue) as Encodable
        default:
            return nil
        }
    }
    
    private struct FavoriteEncodable: Encodable {
        let media_type: String
        let media_id: Int
        let favorite: Bool
    }
}
