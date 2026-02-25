import Foundation

protocol UserSessionNetworkManagerProtocol: Sendable {
    func getCurrentUser(sessionId: String) async throws -> TmdbUser
    func getRequestToken() async throws -> String
    func createSession(requestToken: String) async throws -> String
    func getUserRatedMoviesList(page: Int, sessionId: String) async throws -> UserRatedMovieListResponse
}

struct UserSessionNetworkManager: UserSessionNetworkManagerProtocol {
    
    private let client: HTTPClientProtocol
    
    private struct RequestTokenResponse: Decodable {
        let success: Bool
        let request_token: String
    }
    
    private struct SessionResponse: Decodable {
        let success: Bool
        let session_id: String
    }
    
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    func getCurrentUser(sessionId: String) async throws -> TmdbUser {
        return try await client.get(endpoint: UserEndpoint.currentUser(sessionID: sessionId))
    }
    
    func getRequestToken() async throws -> String {
        let model: RequestTokenResponse = try await client.get(endpoint: UserEndpoint.requestToken)
        return model.request_token
    }
    
    func createSession(requestToken: String) async throws -> String {
        let model: SessionResponse = try await client.post(endpoint: UserEndpoint.createSession(requestToken: requestToken))
        return model.session_id
    }
    
    func getUserRatedMoviesList(page: Int, sessionId: String) async throws -> UserRatedMovieListResponse {
        return try await client.get(endpoint: UserEndpoint.userRatedMoviesList(sessionId: sessionId))
    }
    
}
