import CoreNetwork
import CoreEnvironment
import SwiftUI

public struct ProfileView: View {
    
    @Environment(UserSessionStore.self) var userSessionStore
    @Environment(UserPreferences.self) var userPreferences
    @Environment(CommonDataStore.self) var commonDataStore
    
    @State private var viewDidAppear: Bool = false
    
    public init() { }
    
    public var body: some View {
        List {
            if let user = userSessionStore.user, let currentSessionId = userSessionStore.currentSessionId {
                Section {
                    ProfileImageView(appConfiguration: commonDataStore.configuration, profilePath: user.avatar.tmdb.avatarPath)
                    Text(verbatim: user.name)
                        .font(.largeTitle)
                }
                if let rated = userSessionStore.userRatedMoviesList {
                    Section {
                        #warning("Fix")                        
                        NavigationLink(value: RouteDestination.paginatedList(.userRated(userId: "\(user.id)", type: .movies, sessionId: currentSessionId, initial: rated))) {
                            LabeledContent("Rated", value: "\(rated.totalResults)")
                        }
                    }
                }
                if let watchlist = userSessionStore.userWatchlistMoviesList {
                    Section {
                        #warning("Fix")
                        NavigationLink(value: RouteDestination.paginatedList(.userWatchlist(userId: "\(user.id)", type: .movies, sessionId: currentSessionId, initial: watchlist))) {
                            LabeledContent("Watchlist", value: "\(watchlist.totalResults)")
                        }
                    }
                }
            }
            
            Section("Settings") {
                NavigationLink(value: RouteDestination.allLanguages(all: commonDataStore.allLanguages, current: userPreferences.appLanguage)) {
                    LabeledContent("Language", value: userPreferences.appLanguage)
                }
            }
            
            Section {
                let isAuth = userSessionStore.user != nil
                Button(isAuth ? "Logout" : "Login", role: isAuth ? .destructive : .confirm) {
                    if !isAuth {
                        userSessionStore.startSession(lang: userPreferences.appLanguage)
                    }
                }
            } header: {
                Text(verbatim: "Auth")
            }
        }
        .onChange(of: userPreferences.appLanguage, initial: false) { oldValue, newValue in
            guard oldValue != newValue else { return }
            Task {
                await userSessionStore.fetchUserData(lang: newValue)
            }
        }
    }
}
