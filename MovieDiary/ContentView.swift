import SwiftUI

struct ContentView: View {
    
    @Environment(UserSessionStore.self) var userSessionStore
    @State private var selectedTab: AppTab = .main
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.tabs, id: \.self) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
    }
    
    
    @ViewBuilder
    private func tabView(for tab: AppTab) -> some View {
        switch tab {
        case .main:
            MainView()
        case .profile:
            if let user = userSessionStore.user, let rated = userSessionStore.userRatedMoviesList {
                ProfileView(user: user, rated: rated)
            } else {
                LoginView()
            }
        }
    }
}




#Preview {
    ContentView()
}
