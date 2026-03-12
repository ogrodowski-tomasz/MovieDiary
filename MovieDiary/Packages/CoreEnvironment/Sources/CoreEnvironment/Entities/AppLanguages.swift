import Foundation

public struct AppLanguages: Decodable, Sendable, Hashable {
    public let iso_639_1: String
    public let english_name: String
    public let name: String
    
    internal static let `default`: AppLanguages = .init(iso_639_1: "en", english_name: "English", name: "English")
}

public extension Array where Element == AppLanguages {
    func resolve(for id: String) -> AppLanguages {
        first(where: { $0.iso_639_1.localizedCaseInsensitiveContains(id) }) ?? .default
    }
}
