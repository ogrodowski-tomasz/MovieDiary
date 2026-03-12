import SwiftUI

public extension View {
    func redactWithPlaceholder(when condition: Bool) -> some View {
        redacted(reason: condition ? .placeholder : [])
    }
}
