import Foundation

extension HTTPClientProtocol {
    func get<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await get(endpoint: endpoint)
    }

    func post<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await post(endpoint: endpoint)
    }
}

public final class MockHTTPClient: HTTPClientProtocol {
    
    enum MockError: Error {
        case wrongEndpoint(Endpoint)
        case missingFilename(Endpoint)
        case noFileInBundle(String)
        case noDataAtPath(String)
    }

    public init() { }

    public func get<Entity>(endpoint: Endpoint) async throws -> Entity where Entity : Decodable {
        try getStaticData(endpoint: endpoint)
    }

    public func post<Entity>(endpoint: Endpoint) async throws -> Entity where Entity : Decodable {
        try getStaticData(endpoint: endpoint)
    }

    private func getStaticData<Entity: Decodable>(endpoint: Endpoint) throws -> Entity {
//        guard let endpoint = endpoint as? StubEndpoint else {
//            throw MockError.wrongEndpoint(endpoint)
//
//        }
//        guard let file = endpoint.stubDataFilename, !file.isEmpty else {
//            throw MockError.missingFilename(endpoint)
//        }
//
//        guard let url = Bundle.module.url(forResource: file, withExtension: "json") else {
//            throw MockError.noFileInBundle(file)
//        }
//
//        let data = try Data(contentsOf: url)
//
//        let decoder = JSONDecoder()
//        return try decoder.decode(Entity.self, from: data)
        throw MockError.wrongEndpoint(endpoint)
    }
}
