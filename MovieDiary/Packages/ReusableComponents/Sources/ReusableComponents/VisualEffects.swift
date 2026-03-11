import SwiftUI

public extension View {
    
    func resizingOnScroll() -> some View {
        visualEffect { effect, geo in
            let currentHeight = geo.size.height
            let scrollOffset = geo.frame(in: .scrollView).minY
            let positiveOffset = max(0, scrollOffset)
            let scaleFactor = (currentHeight + positiveOffset) / currentHeight
            return effect.scaleEffect(x: scaleFactor, y: scaleFactor, anchor: .bottom)
        }
    }
}
