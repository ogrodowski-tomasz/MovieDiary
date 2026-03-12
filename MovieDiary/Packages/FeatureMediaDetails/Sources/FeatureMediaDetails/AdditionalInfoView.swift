import SwiftUI

struct AdditionalInfoView: View {
    
    let info: [LocalizedStringResource]
    let redacted: Bool
    
    private var joined: String {
        info.map { String(localized: $0) }.joined(separator: " · ")
    }
    
    init(info: [LocalizedStringResource], redacted: Bool) {
        self.info = info
        self.redacted = redacted
    }
    
    var body: some View {
        Text(joined)
            .font(.headline)
            .redactWithPlaceholder(when: redacted)
    }
}

//#Preview {
//    AdditionalInfoView()
//}
