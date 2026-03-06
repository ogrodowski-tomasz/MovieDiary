import Foundation
import Models
import NetworkClient
import AuthenticationServices
import OSLog

@Observable
final class UserSessionStore: NSObject {
    
    var user: TmdbUser?
    var userRatedMoviesList: UserRatedMovieListResponse?
    var currentSessionId: String?
    var shouldAuthenticateApp: Bool = false
    
    private let userSessionNetworkmanager: UserSessionNetworkManagerProtocol
    private let sessionStorage: UserSessionStoreProtocol
    
    private var authSession: ASWebAuthenticationSession?

    private let callbackScheme = "myapp"
    
    private var currentRequestToken: String?
    
    private let logger = Logger(category: "UserSessionStore")
    
    init(userSessionNetworkmanager: UserSessionNetworkManagerProtocol, sessionStorage: UserSessionStoreProtocol) {
        self.userSessionNetworkmanager = userSessionNetworkmanager
        self.sessionStorage = sessionStorage
    }
    
    func fetchCurrentUser() async {
        do {
            logger.info("Starting to fetch current user")
            guard let currentSessionId = sessionStorage.loadSession() else { return }
            user = try await userSessionNetworkmanager.getCurrentUser(sessionId: currentSessionId)
            logger.info("Successfully fetched current user")
            await fetchUserData()
        } catch {
            logger.error("Error fetching current user: \(error.localizedDescription)")
        }
    }
    
    func fetchUserData() async {
        do {
            logger.info("Starting to fetch user rated movies")
            guard let currentSessionId = sessionStorage.loadSession() else { return }
            async let userRatedMoviesResponse = await userSessionNetworkmanager.getUserRatedMoviesList(page: 1, sessionId: currentSessionId)
            let data = try await userRatedMoviesResponse
            self.userRatedMoviesList = data
            logger.info("Successfully fetched user rated movies")
        } catch {
            logger.error("Error fetching user rated movies: \(error.localizedDescription)")
        }
    }
    
    func startSession() {
        Task {
            do {
                let requestToken: String
                
                if let currentRequestToken {
                    requestToken = currentRequestToken
                } else {
                    requestToken = try await userSessionNetworkmanager.getRequestToken()
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
            let sessionId = try await userSessionNetworkmanager.createSession(requestToken: currentRequestToken)
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
    
}

extension UserSessionStore: ASWebAuthenticationPresentationContextProviding {

    func presentationAnchor(
        for session: ASWebAuthenticationSession
    ) -> ASPresentationAnchor {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first!
            .windows.first!
    }
}
