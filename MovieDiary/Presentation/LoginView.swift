import SwiftUI
import EnvObjects

struct LoginView: View {
    @Environment(UserSessionStore.self) var userSessionStore
    var body: some View {
        NavigationStack {
            Button("Login") {
                userSessionStore.startSession()
            }
            .navigationTitle("Profile")
            .withRouter()
        }
    }
}

#Preview {
    LoginView()
}
