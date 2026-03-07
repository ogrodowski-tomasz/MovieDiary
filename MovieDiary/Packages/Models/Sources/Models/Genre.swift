import Foundation

public struct Genre: Codable, Sendable, Identifiable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public extension Array where Element == Genre {
    func join(separator: String = " · ") -> String {
        return self.map(\.name).joined(separator: separator)
    }
}
