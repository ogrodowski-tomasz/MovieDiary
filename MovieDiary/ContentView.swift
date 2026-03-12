import CoreDesign
import CoreEnvironment
import FeatureMain
import FeatureProfile
import SwiftUI

struct ContentView: View {
    
    @Environment(\.httpClient) var httpClient
    @Environment(UserSessionStore.self) var userSessionStore
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(UserPreferences.self) var userPreferences
    @Environment(Router.self) var router
    
    @State private var presentOverlay: Bool = true
    
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
                        NavigationStack(path: $router.profilePath) {
                            ProfileView()
                                .withRouter()
                        }
                    }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
                .tag(tab)
            }
        }.onChange(of: userPreferences.appLanguage) { oldValue, newValue in
            guard oldValue != newValue else {
                return
            }
            presentOverlay = true
            router.clear()
        }.fullScreenCover(isPresented: $presentOverlay) {
            ZStack {
                Color.green.ignoresSafeArea()
                VStack {
                    Text(verbatim: "Loading diary")
                    ProgressView()
                }
            }
            .task {
                userSessionStore.injectClient(httpClient)
                commonDataStore.injectClient(httpClient)
                await commonDataStore.getCommonData(lang: userPreferences.appLanguage)
                await userSessionStore.fetchCurrentUser(lang: userPreferences.appLanguage)
                presentOverlay = false
            }
        }
    }
}

#Preview {
    ContentView()
}
