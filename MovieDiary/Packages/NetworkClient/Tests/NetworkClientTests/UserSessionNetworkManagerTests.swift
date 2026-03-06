@testable import NetworkClient
import Testing

struct UserSessionNetworkManagerTests {

    let sut: UserSessionNetworkManagerProtocol

    init() {
        sut = UserSessionNetworkManager(client: MockHTTPClient())
    }

    @Test func test_getRequestToken() async throws {
        let expectedValue = "9bbd53fa00f3e8848cebf205f8d79e5128e6dc39"
        let data = try await sut.getRequestToken()
        #expect(data == expectedValue)
    }

    @Test func test_getUserRatedMoviesList() async throws {
        let expectedValue = "StubMovieTitle"
        let data = try await sut.getUserRatedMoviesList(page: 1, sessionId: "")
        #expect(data.results.first?.title == expectedValue)
    }

}
