import SwiftUI
import EnvObjects

struct LoginView: View {
    @Environment(UserSessionStore.self) var userSessionStore
    var body: some View {
        NavigationStack {
            Button {
                userSessionStore.startSession()
            } label: {
                Text(verbatim: "Login")
            }
//            .navigationTitle("Profile")
            .withRouter()
        }
    }
}

#Preview {
    LoginView()
}
