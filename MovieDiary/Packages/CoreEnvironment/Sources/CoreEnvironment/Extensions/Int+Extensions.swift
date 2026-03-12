import Foundation

internal extension Int {
    var asRuntime: String {
        let hours = self / 60
        let minutes = self % 60
        return hours > 0 ? "\(hours)h \(minutes)min" : "\(minutes)min"
    }
}
