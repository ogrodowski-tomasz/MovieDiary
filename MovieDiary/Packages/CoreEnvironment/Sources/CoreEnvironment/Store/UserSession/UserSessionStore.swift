import Foundation
import CoreNetwork
import AuthenticationServices
import OSLog

@MainActor
@Observable
public final class UserSessionStore: NSObject, Store {

    public func injectClient(_ httpClient: any HTTPClientProtocol) {
        self.client = httpClient
    }

    private var client: HTTPClientProtocol?

    public var user: TmdbUser?
    public var userRatedMoviesList: ListResponseModel?
    public var userWatchlistMoviesList: ListResponseModel?
    
    public var currentSessionId: String? {
        get { sessionStorage.currentSessionId }
        set { sessionStorage.currentSessionId = newValue }
    }
    
    public var currentUserId: String? {
        get { sessionStorage.userId }
        set { sessionStorage.userId = newValue }
    }
    
    var shouldAuthenticateApp: Bool = false

    private var sessionStorage: UserSessionStoreProtocol
    
    private var authSession: ASWebAuthenticationSession?

    private let callbackScheme = "myapp"
    
    private var currentRequestToken: String?
    
    private let logger = Logger(subsystem: "CoreEnvironment", category: "UserSessionStore")
    
    public init(sessionStorage: UserSessionStoreProtocol) {
        self.sessionStorage = sessionStorage
    }
    
    public func fetchCurrentUser(lang: String) async {
        do {
            logger.info("Starting to fetch current user")
            user = try await getCurrentUser()
            logger.info("Successfully fetched current user")
            await fetchUserData(lang: lang)
        } catch let error as StoreError {
            logger.error("StoreError fetching current user: \(error.localizedDescription)")
        } catch {
            logger.error("Generic Error fetching current user: \(error.localizedDescription)")
        }
    }
    
    public func fetchUserData(lang: String) async {
        do {
            logger.info("Starting to fetch user rated movies")
            async let userRatedMoviesResponse = await getUserRatedMoviesList(lang: lang)
            async let userWatchlistMoviesResponse = await getUserWatchlistMoviesList(lang: lang)
            #warning("Improve to reduce number of view redraws")
            let data = try await (userRatedMoviesResponse, userWatchlistMoviesResponse)
            self.userRatedMoviesList = data.0
            self.userWatchlistMoviesList = data.1
            logger.info("Successfully fetched user rated movies")
        } catch let error as StoreError {
            logger.error("StoreError fetching user rated movies: \(error.localizedDescription)")
        } catch {
            logger.error("Generic Error fetching user rated movies: \(error.localizedDescription)")
        }
    }
    
    public func startSession(lang: String) {
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
                startWebAuth(token: requestToken, url: authURL, lang: lang)
            } catch {
                logger.error("Error starting session: \(error.localizedDescription)")
            }
        }
    }
    
    public func toggleMovieFavorite(id: Int, newValue: Bool) async throws -> MovieAccountStateModel {
        guard let client else { throw StoreError.missingClient }
        guard let currentSessionId else { throw StoreError.missingSessionId }
        guard let user else { throw StoreError.missingUser }
        let response: FavoriteResponse = try await client.post(
            endpoint: UserEndpoint.toggleFavoriteMovie(
                userId: user.id,
                movieId: id,
                sessionId: currentSessionId,
                newValue: newValue
            ).endpoint
        )
        guard response.success else {
            throw URLError(.unknown)
        }
        return try await getMovieAccountState(id: id)
    }
    
    public func toggleMovieWatchlist(id: Int, newValue: Bool) async throws -> MovieAccountStateModel {
        guard let client else { throw StoreError.missingClient }
        guard let currentSessionId else { throw StoreError.missingSessionId }
        guard let user else { throw StoreError.missingUser }
        let response: FavoriteResponse = try await client.post(
            endpoint: UserEndpoint.toggleOnWatchListStatus(
                userId: user.id,
                movieId: id,
                sessionId: currentSessionId,
                newValue: newValue
            ).endpoint
        )
        guard response.success else {
            throw URLError(.unknown)
        }
        return try await getMovieAccountState(id: id)
    }
    
    public func getMovieAccountState(id: Int) async throws -> MovieAccountStateModel {
        guard let client else { throw StoreError.missingClient }
        guard let currentSessionId else { throw URLError(.unknown) }
        return try await client.get(endpoint: UserEndpoint.movieAccountState(movieId: id, sessionId: currentSessionId).endpoint)
    }
    
    private func startWebAuth(token: String, url: URL, lang: String) {

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
                    token: token,
                    lang: lang
                )
            }
        }

        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = false
        authSession?.start()
    }
    
    private func handleCallback(callbackURL: URL,
                                token: String, lang: String) async {

        guard let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
              let approved = components.queryItems?.first(where: {$0.name == "approved"})?.value,
              approved == "true",
            let currentRequestToken
        else {
            return
        }

        do {
            currentSessionId = try await createSession(requestToken: currentRequestToken)
            if let currentSessionId {
                logger.info("Obtained current sessionId: \(currentSessionId)")
                await fetchCurrentUser(lang: lang)
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
    
    private struct FavoriteResponse: Decodable {
        let success: Bool
        let status_code: Int
        let status_message: String
    }

    public func getCurrentUser() async throws -> TmdbUser {
        guard let client else { throw StoreError.missingClient }
        guard let currentSessionId else { throw StoreError.missingSessionId }
        guard let id = sessionStorage.userId else { throw StoreError.missingUser }
        let fetched: TmdbUser = try await client.get(endpoint: UserEndpoint.currentUser(id: id, sessionID: currentSessionId).endpoint)
        sessionStorage.userId = "\(fetched.id)"
        return fetched
    }

    public func getRequestToken() async throws -> String {
        guard let client else { throw StoreError.missingClient }
        let model: RequestTokenResponse = try await client.get(endpoint: UserEndpoint.requestToken.endpoint)
        return model.request_token
    }

    public func createSession(requestToken: String) async throws -> String {
        guard let client else { throw StoreError.missingClient }
        let model: SessionResponse = try await client.post(endpoint: UserEndpoint.createSession(requestToken: requestToken).endpoint)
        return model.session_id
    }

    public func getUserRatedMoviesList(lang: String) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        guard let currentSessionId else { throw StoreError.missingSessionId }
        guard let id = sessionStorage.userId else { throw StoreError.missingUser }
        return try await client.get(endpoint: UserEndpoint.userRatedMoviesList(userId: id, sessionId: currentSessionId, page: 1, language: lang).endpoint)
    }
    
    public func getUserWatchlistMoviesList(lang: String) async throws -> ListResponseModel {
        guard let client else { throw StoreError.missingClient }
        guard let currentSessionId else { throw StoreError.missingSessionId }
        guard let id = sessionStorage.userId else { throw StoreError.missingUser }
        return try await client.get(endpoint: UserEndpoint.userWatchlistMoviesList(userId: id, sessionId: currentSessionId, page: 1, language: lang).endpoint)
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
