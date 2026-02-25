import SwiftUI

struct MainView: View {
    @Environment(UserSessionStore.self) var userSessionStore
    var body: some View {
        NavigationStack {
            Text(userSessionStore.currentSessionId ?? "No session")
                .navigationTitle("Main")
        }
    }
}

#Preview {
    MainView()
}
