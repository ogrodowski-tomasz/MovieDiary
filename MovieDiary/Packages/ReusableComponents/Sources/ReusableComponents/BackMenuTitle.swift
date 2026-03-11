import SwiftUI

public extension View {
    func backMenuTitle(_ title: String) -> some View {
        modifier(BackMenuTitleViewModifier(title: title))
    }
}

struct BackMenuTitleViewModifier: ViewModifier {
    
    let title: String
    @State private var present: Bool = false
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(present ? title : "")
            .onAppear {
               present = false
            }
            .onDisappear {
                present = true
            }
        
    }
}
