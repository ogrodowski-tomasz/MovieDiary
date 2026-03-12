import Foundation
import OSLog

public protocol HTTPClientProtocol {
    func get<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity
    func post<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity
}

public struct HTTPClient: HTTPClientProtocol {

    let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let memoryCapacity: Int = 1024 * 1024 * 10
        let diskCapacity: Int = 1024 * 1024 * 50
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
        configuration.urlCache = cache
        configuration.requestCachePolicy = .useProtocolCachePolicy // basing on Etag
        return URLSession(configuration: configuration)
    }()

    public let environment: ClientEnvironment

    private let logger: Logger

    public init(environment: ClientEnvironment) {
        self.environment = environment
        logger = Logger(subsystem: "CoreNetwork", category: environment.subsystem)
    }

    public func post<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await makeEntityRequest(endpoint: endpoint, method: .post)
    }

    public func get<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        try await makeEntityRequest(endpoint: endpoint, method: .get)
    }

    package func makeEntityRequest<Entity: Decodable>(endpoint: Endpoint, method: HTTPMethod) async throws -> Entity {
        let url = try makeURL(endpoint: endpoint)
        let request = try makeURLRequest(url: url, endpoint: endpoint, method: method)
        let (data, response) = try await urlSession.data(for: request)
        #warning("Improve because when there is an error, the response is not logged")
        logger.log(level: .info, "\(request)")
        logger.logResponseOnError(httpResponse: response, data: data)
        return try JSONDecoder().decode(Entity.self, from: data)
    }

    package func makeURL(scheme: String = "https", endpoint: Endpoint) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = environment.host

        components.path += "/3"
        components.path += endpoint.path
        if let items = endpoint.queryItems, !items.isEmpty {
            components.queryItems = items
        }

        guard let url = components.url else {
            throw HTTPError.invalidRequest(endpoint)
        }
        return url
    }

    private func makeURLRequest(url: URL, endpoint: Endpoint, method: HTTPMethod) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(AppKey.appKey)", forHTTPHeaderField: "Authorization")

        if let jsonValue = endpoint.jsonValue {
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(jsonValue)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw HTTPError.invalidJsonData(endpoint, error)
            }
        }
        return request
    }
}
