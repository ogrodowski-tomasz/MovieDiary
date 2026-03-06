import Foundation
import Models
import NetworkClient
import AuthenticationServices
import OSLog

@MainActor
@Observable
public final class UserSessionStore: NSObject, Store {

    public func injectClient(_ httpClient: any NetworkClient.HTTPClientProtocol) {
        self.client = httpClient
    }
    

    private var client: HTTPClientProtocol?

    public var user: TmdbUser?
    public var userRatedMoviesList: UserRatedMovieListResponse?
    var currentSessionId: String?
    var shouldAuthenticateApp: Bool = false

    private let sessionStorage: UserSessionStoreProtocol
    
    private var authSession: ASWebAuthenticationSession?

    private let callbackScheme = "myapp"
    
    private var currentRequestToken: String?
    
    private let logger = Logger(category: "UserSessionStore")
    
    public init(sessionStorage: UserSessionStoreProtocol) {
        self.sessionStorage = sessionStorage
    }
    
    public func fetchCurrentUser() async {
        do {
            logger.info("Starting to fetch current user")
            guard let currentSessionId = sessionStorage.loadSession() else { return }
            user = try await getCurrentUser(sessionId: currentSessionId)
            logger.info("Successfully fetched current user")
            await fetchUserData()
        } catch {
            logger.error("Error fetching current user: \(error.localizedDescription)")
        }
    }
    
    public func fetchUserData() async {
        do {
            logger.info("Starting to fetch user rated movies")
            guard let currentSessionId = sessionStorage.loadSession() else { return }
            async let userRatedMoviesResponse = await getUserRatedMoviesList(page: 1, sessionId: currentSessionId)
            let data = try await userRatedMoviesResponse
            self.userRatedMoviesList = data
            logger.info("Successfully fetched user rated movies")
        } catch {
            logger.error("Error fetching user rated movies: \(error.localizedDescription)")
        }
    }
    
    public func startSession() {
        Task {
            do {
                let requestToken: String
                
                if let currentRequestToken {
                    requestToken = currentRequestToken
                } else {
                    requestToken = try await getRequestToken()
                }
                
                let authURL = URL(
                    string:
                    "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=myapp://auth"
                )!
                currentRequestToken = requestToken
                startWebAuth(token: requestToken, url: authURL)
            } catch {
                
            }
        }
    }
    
    private func startWebAuth(token: String, url: URL) {

        authSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackScheme
        ) { callbackURL, error in

            guard error == nil,
                  let callbackURL else {
                return
            }

            Task {
                await self.handleCallback(
                    callbackURL: callbackURL,
                    token: token
                )
            }
        }

        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = false
        authSession?.start()
    }
    
    private func handleCallback(callbackURL: URL,
                                token: String) async {

        guard
            let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
              let approved = components.queryItems?.first(where: {$0.name == "approved"})?.value,
              approved == "true",
            let currentRequestToken
        else {
            return
        }

        do {
            let sessionId = try await createSession(requestToken: currentRequestToken)
            sessionStorage.save(sessionId: sessionId)
            currentSessionId = sessionStorage.loadSession()
            if let currentSessionId {
                logger.info("Obtained current sessionId: \(currentSessionId)")
                await fetchUserData()
            }
        } catch {
            logger.error("Error fetching sessionId: \(error.localizedDescription)")
        }
    }

    private struct RequestTokenResponse: Decodable {
        let success: Bool
        let request_token: String
    }

    private struct SessionResponse: Decodable {
        let success: Bool
        let session_id: String
    }

    public func getCurrentUser(sessionId: String) async throws -> TmdbUser {
        guard let client else { throw URLError(.unknown) }
        return try await client.get(endpoint: UserEndpoint.currentUser(sessionID: sessionId))
    }

    public func getRequestToken() async throws -> String {
        guard let client else { throw URLError(.unknown) }
        let model: RequestTokenResponse = try await client.get(endpoint: UserEndpoint.requestToken)
        return model.request_token
    }

    public func createSession(requestToken: String) async throws -> String {
        guard let client else { throw URLError(.unknown) }
        let model: SessionResponse = try await client.post(endpoint: UserEndpoint.createSession(requestToken: requestToken))
        return model.session_id
    }

    public func getUserRatedMoviesList(page: Int, sessionId: String) async throws -> UserRatedMovieListResponse {
        guard let client else { throw URLError(.unknown) }
        return try await client.get(endpoint: UserEndpoint.userRatedMoviesList(sessionId: sessionId))
    }
}

extension UserSessionStore: ASWebAuthenticationPresentationContextProviding {

    public func presentationAnchor(
        for session: ASWebAuthenticationSession
    ) -> ASPresentationAnchor {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first!
            .windows.first!
    }
}
