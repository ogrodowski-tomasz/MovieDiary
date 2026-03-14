import Foundation

public extension URLQueryItem {
    static func page(_ page: Int) -> Self {
        return .init(name: "page", value: "\(page)")
    }
    
    static func language(_ language: String) -> Self {
        return .init(name: "language", value: language)
    }
    
    static func sessionId(_ sessionId: String) -> Self {
        return .init(name: "session_id", value: sessionId)
    }
}
