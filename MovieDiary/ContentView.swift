import CoreDesign
import CoreEnvironment
import FeatureMain
import SwiftUI

struct ContentView: View {

    @Environment(UserSessionStore.self) var userSessionStore
    @Environment(Router.self) var router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .main:
                        NavigationStack(path: $router.mainPath) {
                            MainView()
                                .withRouter()
                        }
                    case .profile:
                        if let user = userSessionStore.user, let rated = userSessionStore.userRatedMoviesList {
                            ProfileView(user: user, rated: rated)
                        } else {
                            LoginView()
                        }
                    }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
                .tag(tab)
            }
        }
    }
}

#Preview {
    ContentView()
}
