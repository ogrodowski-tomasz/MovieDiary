import CoreNetwork
import Foundation
import SwiftUI

public protocol Previewable: Decodable {
    static var sample: Self { get }
}

extension Array: Previewable where Element: Previewable {
    public static var sample: Self { .init([.sample]) }
}

public struct MockHTTPClient: HTTPClientProtocol {
    public func get<Entity>(endpoint: Endpoint) async throws -> Entity where Entity: Decodable {
        guard let preview = Entity.self as? any Previewable.Type else {
            throw HTTPError.invalidRequest(endpoint)
        }
        guard let sample = preview.sample as? Entity else {
            throw HTTPError.invalidRequest(endpoint)
        }
        return sample
    }

    public func post<Entity: Decodable>(endpoint: Endpoint) async throws -> Entity {
        throw HTTPError.invalidRequest(endpoint)
    }
}

public extension View {
    func previewEnvironment() -> some View {
        modifier(PreviewViewModifier())
    }
}

struct PreviewViewModifier: ViewModifier {

    @State private var router = Router()
    @State private var commonDataStore = CommonDataStore()
    @State private var userDataStore = UserSessionStore(sessionStorage: KeychainService())
    @State private var userPreferences = UserPreferences.shared
    let client = MockHTTPClient()

    func body(content: Content) -> some View {
        content
            .environment(\.httpClient, client)
            .environment(router)
            .environment(userPreferences)
            .environment(commonDataStore)
            .environment(userDataStore)
            .task {
                commonDataStore.injectClient(client)
                userDataStore.injectClient(client)
                await commonDataStore.getCommonData(lang: "en")
                await userDataStore.fetchCurrentUser(lang: "en")
            }
    }
}
