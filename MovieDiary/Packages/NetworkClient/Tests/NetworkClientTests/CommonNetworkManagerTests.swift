import Testing
@testable import NetworkClient

struct CommonNetworkManagerTests {

    let sut: CommonNetworkManagerProtocol

    init() {
        sut = CommonNetworkManager(client: MockHTTPClient())
    }

    @Test func test_getAppConfiguration() async throws {
        let expectedValue = "mock_key"
        let data = try await sut.getAppConfiguration()
        #expect(data.changeKeys.isEmpty == false)
        #expect(data.changeKeys.first == expectedValue)
    }

}
