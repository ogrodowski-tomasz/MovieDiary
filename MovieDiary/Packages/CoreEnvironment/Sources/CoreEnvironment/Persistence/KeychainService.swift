import SwiftUI
import AuthenticationServices
import Foundation
import Security

public protocol UserSessionStoreProtocol: Sendable {
    func save(sessionId: String)
    func loadSession() -> String?
}

public struct KeychainService: UserSessionStoreProtocol {

    public init() { }

    public func save(sessionId: String) {
        let data = Data(sessionId.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "tmdb_session",
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    public func loadSession() -> String? {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "tmdb_session",
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

struct MockUserSessionStore: UserSessionStoreProtocol {
    
    func save(sessionId: String) {}
    
    func loadSession() -> String? {
        "DummySessionId"
    }
}
