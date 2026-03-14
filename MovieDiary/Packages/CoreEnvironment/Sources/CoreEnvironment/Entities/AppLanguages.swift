import Foundation

public struct AppLanguages: Decodable, Sendable, Hashable {
    public let iso_639_1: String
    public let english_name: String
    public let name: String
    
    internal static let `default`: AppLanguages = .init(iso_639_1: "en", english_name: "English", name: "English")
    
    public var flagEmoji: String {
        iso_639_1
            .uppercased()
            .unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}


extension AppLanguages: Previewable {
    public static var sample: AppLanguages { .default }
}

public extension Array where Element == AppLanguages {
    func resolve(for id: String?) -> AppLanguages {
        guard let id else { return .default }
        return first(where: { $0.iso_639_1.localizedCaseInsensitiveContains(id) }) ?? .default
    }
    
    func excluding(_ lang: AppLanguages) -> Self {
        filter { $0 != lang }
            .sorted { lhs, rhs in
                if lhs == .default { return true }
                if rhs == .default { return false }
                return lhs.english_name < rhs.english_name
            }
    }
}
