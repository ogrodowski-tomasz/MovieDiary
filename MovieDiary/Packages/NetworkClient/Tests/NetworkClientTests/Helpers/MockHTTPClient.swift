import Foundation
@testable import NetworkClient

extension HTTPClientProtocol {
    func get<Entity: Decodable>(endpoint: any StubEndpoint) async throws -> Entity {
        try await get(endpoint: endpoint)
    }

    func post<Entity: Decodable>(endpoint: any StubEndpoint) async throws -> Entity {
        try await post(endpoint: endpoint)
    }
}

final class MockHTTPClient: HTTPClientProtocol {

    init() { }

    func get<Entity>(endpoint: any Endpoint) async throws -> Entity where Entity : Decodable {
        try getStaticData(endpoint: endpoint)
    }

    func post<Entity>(endpoint: any Endpoint) async throws -> Entity where Entity : Decodable {
        try getStaticData(endpoint: endpoint)
    }

    private func getStaticData<Entity: Decodable>(endpoint: any Endpoint) throws -> Entity {
        guard let endpoint = endpoint as? StubEndpoint else {
            throw URLError(.badServerResponse)

        }
        guard let file = endpoint.stubDataFilename, !file.isEmpty else {
            throw URLError(.badServerResponse)
        }

        guard let url = Bundle.module.url(forResource: file, withExtension: "json") else {
            throw URLError(.badServerResponse)
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        return try decoder.decode(Entity.self, from: data)
    }
}
