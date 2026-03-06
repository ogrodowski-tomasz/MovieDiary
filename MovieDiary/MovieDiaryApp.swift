import Models
import NetworkClient
import SwiftUI

@main
struct MovieDiaryApp: App {
    
    let keychainService: UserSessionStoreProtocol
    @State private var userSessionStore: UserSessionStore
    @State private var commonDataStore: CommonDataStore
    @State private var listDataStore: ListDataStore

    init() {
        let httpClient = HTTPClient()
        keychainService = KeychainService()
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
                .task {
                    await userSessionStore.fetchCurrentUser()
                    await commonDataStore.getConfiguration()
                }
        }
    }
}
