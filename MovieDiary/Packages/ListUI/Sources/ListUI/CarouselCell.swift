import Models
import EnvObjects
import NetworkClient
import SwiftUI
import ReusableComponents

struct CarouselCell<Item: CarouselModel>: View {
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(Router.self) var router
    
    var img: URL? {
        commonDataStore.configuration?.images.poster(for: item.posterPath)
    }

    let item: Item

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Button {
                #warning("Improve")
                if let item = item as? MovieModel {
                    router.push(to: .details(id: item.id, posterPath: item.posterPath, title: item.title, overview: item.overview, listType: item.listType))
                } else if let item = item as? MovieRecommendationModel {
                    router.push(to: .details(id: item.id, posterPath: item.posterPath, title: item.title, overview: item.overview, listType: item.listType))
                }
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
