import Foundation

public struct AppLanguages: Decodable, Sendable, Hashable {
    let iso_639_1: String
    let english_name: String
    let name: String
}
