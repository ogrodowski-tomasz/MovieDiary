import Foundation

public enum UserEndpoint: Endpoint {
    case requestToken
    case currentUser(sessionID: String)
    case createSession(requestToken: String)
    case userRatedMoviesList(sessionId: String)
    
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
        }
    }
    
    public var jsonValue: Encodable? {
        switch self {
        case let .createSession(requestToken):
            return [
                "request_token": requestToken
            ] as Encodable
        default:
            return nil
        }
    }
}
