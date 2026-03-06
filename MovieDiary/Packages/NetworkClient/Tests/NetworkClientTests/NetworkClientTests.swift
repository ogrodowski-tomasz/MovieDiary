import Testing
import Models
@testable import NetworkClient

@Test func example() async throws {

    let client = MockHTTPClient()

    let data: UserRatedMovieListResponse = try await client.get(endpoint: UserEndpoint.userRatedMoviesList(sessionId: "xxxxx"))

    #expect(data.results.first?.title == "StubMovieTitle")
}
