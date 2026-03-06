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

    init() {
        let httpClient = HTTPClient()
        userSessionStore = UserSessionStore(
            userSessionNetworkmanager: UserSessionNetworkManager(
                client: httpClient
            ),
            sessionStorage: keychainService
        )
        commonDataStore = CommonDataStore(
            commonNetworkManager: CommonNetworkManager(
                client: httpClient
            )
        )
        listDataStore = ListDataStore(
            listNetworkManager: ListNetworkManager(
                client: httpClient
            )
        )
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userSessionStore)
                .environment(commonDataStore)
                .environment(listDataStore)
                .environment(router)
                .task {
                    await userSessionStore.fetchCurrentUser()
                    await commonDataStore.getConfiguration()
                }
        }
    }
}
