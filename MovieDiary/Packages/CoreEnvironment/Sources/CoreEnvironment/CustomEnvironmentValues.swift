import CoreNetwork
import SwiftUI

public extension EnvironmentValues {
    @Entry var httpClient: HTTPClientProtocol = HTTPClient(environment: .prod)
}
