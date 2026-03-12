import Foundation

public struct AppLanguages: Decodable, Sendable, Hashable {
    public let iso_639_1: String
    public let english_name: String
    public let name: String
    
    public static let `default`: AppLanguages = .init(iso_639_1: "pl", english_name: "Polish", name: "Polish")
}
