import CoreEnvironment
import SwiftUI

struct CastCarouselCell: View {
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(Router.self) var router
    
    var img: URL? {
        commonDataStore.configuration?.images.profile(for: item.profilePath)
    }

    let item: CastCrewModel
    
    var name: String {
        item.name//.replacingOccurrences(of: "", with: "\n")
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button {
//                router.push(to: .details(item))
            } label: {
                let side: CGFloat = 80
                AvatarView(config: .init(url: img, width: side, height: side, cornerRadius: 8))
                    .buttonStyle(.glassProminent)
            }
            VStack(alignment: .center, spacing: 0) {
                Text(name)
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                Text(item.occupancy)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 85)
            Spacer()
        }
    }
}
