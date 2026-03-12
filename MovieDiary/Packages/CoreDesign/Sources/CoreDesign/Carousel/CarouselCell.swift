import CoreEnvironment
import CoreNetwork
import SwiftUI

struct CarouselCell: View {
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(Router.self) var router
    
    var img: URL? {
        commonDataStore.configuration?.images.poster(for: item.posterPath)
    }

    let item: ListModel

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Button {
                router.push(to: .details(item))
            } label: {
                PosterImageView(config: .init(url: img, width: 120, height: 180, cornerRadius: 8))
                    .buttonStyle(.glassProminent)
            }
            Text(item.title)
                .foregroundStyle(.primary)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 120, alignment: .center)
        }
    }
}
