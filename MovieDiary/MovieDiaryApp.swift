import EnvObjects
import Models
import NetworkClient
import SwiftUI

@main
struct MovieDiaryApp: App {

    let keychainService = KeychainService()
    @State private var userSessionStore: UserSessionStore
    @State private var commonDataStore: CommonDataStore
    @State private var listDataStore: ListDataStore
    @State private var router = Router()
    let httpClient = HTTPClient()

    init() {
        userSessionStore = UserSessionStore(sessionStorage: keychainService)
        commonDataStore = CommonDataStore()
        listDataStore = ListDataStore()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userSessionStore)
                .environment(commonDataStore)
                .environment(listDataStore)
                .environment(router)
                .environment(\.httpClient, httpClient)
                .task {
                    userSessionStore.injectClient(httpClient)
                    commonDataStore.injectClient(httpClient)
                    await userSessionStore.fetchCurrentUser()
                    await commonDataStore.getConfiguration()
                }
        }
    }
}
