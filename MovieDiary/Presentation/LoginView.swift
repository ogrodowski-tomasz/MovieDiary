import SwiftUI
import CoreEnvironment

struct LoginView: View {
    @Environment(UserSessionStore.self) var userSessionStore
    var body: some View {
        NavigationStack {
            Button {
                userSessionStore.startSession()
            } label: {
                Text(verbatim: "Login")
            }
            .withRouter()
        }
    }
}

#Preview {
    LoginView()
}
