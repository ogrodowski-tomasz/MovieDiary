import NetworkClient
import SwiftUI

public extension EnvironmentValues {
    @Entry var httpClient: HTTPClientProtocol = HTTPClient()
}
