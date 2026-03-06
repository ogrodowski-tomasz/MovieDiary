import Foundation
@testable import NetworkClient

protocol StubEndpoint: Endpoint {
    var stubDataFilename: String? { get }
}
