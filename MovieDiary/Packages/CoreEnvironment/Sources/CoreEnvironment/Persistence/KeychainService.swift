import SwiftUI
import AuthenticationServices
import Foundation
import Security

public protocol UserSessionStoreProtocol: Sendable {
    var currentSessionId: String? { get set }
    var userId: String? { get set }
}

public struct KeychainService: UserSessionStoreProtocol {
    
    public enum Key: String {
        case sessionId = "tmdb_session"
        case userId = "tmdb_user"
    }

    public var currentSessionId: String? {
        get { retrieve(key: .sessionId) }
        set { update(newValue: newValue, key: .sessionId) }
    }
    
    public var userId: String? {
        get { retrieve(key: .userId) ?? "12719379" }
        set { update(newValue: newValue, key: .userId) }
    }
    
    public init() { }
    
    private func update(newValue: String?, key: Key) {
        if let newValue {
            save(value: newValue, forKey: key)
        } else {
            delete(key: key)
        }
    }

    private func save(value: String, forKey key: Key) {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func retrieve(key: Key) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    private func delete(key: Key) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]

        SecItemDelete(query as CFDictionary)
    }
}
