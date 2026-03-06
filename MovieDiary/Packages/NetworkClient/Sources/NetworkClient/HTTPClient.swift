import Foundation
import Models
import Utils
import OSLog

public protocol HTTPClientProtocol: Sendable {
    func get<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity
    func post<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity
}

public struct HTTPClient: HTTPClientProtocol {

    let environment: AppEnvironment
    let urlSession: URLSession
    
    enum HTTPClientError: Error {
        case invalidRequest
    }
    
    private let logger = Logger(category: "HTTPClient")

    public init(environment: AppEnvironment = .prod) {
        self.environment = environment
        urlSession = URLSession.shared
    }
    
    public func post<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await makeEntityRequest(endpoint: endpoint, httpMethod: "POST")
    }
    
    public func get<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await makeEntityRequest(endpoint: endpoint, httpMethod: "GET")
    }
    
    private func makeEntityRequest<Entity: Decodable>(endpoint: Endpoint, httpMethod: String) async throws -> Entity {
        let url = try makeURL(endpoint: endpoint)
        let request = makeURLRequest(url: url, endpoint: endpoint, httpMethod: httpMethod)
        let (data, response) = try await urlSession.data(for: request)
        logger.log(level: .info, "\(request)")
        logger.logResponseOnError(httpResponse: response, data: data)
        return try JSONDecoder().decode(Entity.self, from: data)
    }
    
    private func makeURL(scheme: String = "https", endpoint: Endpoint) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = environment.host
        
        components.path += "/3"
        components.path += endpoint.path()
        components.queryItems = endpoint.queryItems()
        
        guard let url = components.url else {
            throw HTTPClientError.invalidRequest
        }
        
        return url
        
    }
    
    private func makeURLRequest(url: URL, endpoint: Endpoint, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(AppKey.appKey)", forHTTPHeaderField: "Authorization")
        
        if let jsonValue = endpoint.jsonValue {
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(jsonValue)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Failed to encode JSON: \(error)")
            }
        }
        return request
    }
}

public struct MockHTTPClient: HTTPClientProtocol {

    public init() { }

    public func get<Entity>(endpoint: any Endpoint) async throws -> Entity where Entity : Decodable {
        try getStaticData(endpoint: endpoint)
    }
    
    public func post<Entity>(endpoint: any Endpoint) async throws -> Entity where Entity : Decodable {
        try getStaticData(endpoint: endpoint)
    }
    
    private func getStaticData<Entity: Decodable>(endpoint: any Endpoint) throws -> Entity {
        guard let file = endpoint.mockFileName, !file.isEmpty,
              let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(Entity.self, from: data)
    }
}
