import CoreDesign
import CoreEnvironment
import CoreNetwork
import SwiftUI
import Nuke

@main
struct MovieDiaryApp: App {

    let keychainService = KeychainService()
    @State private var userSessionStore: UserSessionStore
    @State private var commonDataStore: CommonDataStore
    @State private var router = Router()
    let httpClient = HTTPClient(environment: .prod)

    init() {
        userSessionStore = UserSessionStore(sessionStorage: keychainService)
        commonDataStore = CommonDataStore()
        ImagePipeline.shared = ImagePipelineProvider.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userSessionStore)
                .environment(commonDataStore)
                .environment(router)
                .environment(\.httpClient, httpClient)
        }
    }
}
