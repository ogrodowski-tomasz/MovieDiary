import Foundation

extension HTTPClientProtocol {
    func get<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await get(endpoint: endpoint)
    }

    func post<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await post(endpoint: endpoint)
    }
}
