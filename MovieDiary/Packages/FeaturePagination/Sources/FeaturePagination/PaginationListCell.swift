import CoreDesign
import CoreEnvironment
import SwiftUI

struct PaginationListCell: View {
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(Router.self) var router
    let model: ListModel
    
    var img: URL? {
        commonDataStore.configuration?.images.poster(for: model.posterPath)
    }
    
    var body: some View {
        Button {
            router.push(to: .details(model))
        } label: {
            HStack(alignment: .center, spacing: 10) {
                PosterImageView(config: .init(url: img, width: 80, height: 120, cornerRadius: 8))
                VStack(alignment: .leading, spacing: 7) {
                    Text(model.title + " (\(model.releaseDate))")
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(model.overview)
                        .lineLimit(2)
                    Text("⭐️\(String(format: "%.1f", model.voteAverage ?? 0))")
                }
            }
        }
        .buttonStyle(.plain)
        .listRowBackground(Color(uiColor: .systemBackground))
        .listRowSeparator(.visible, edges: [.top])
    }
}

//#Preview {
//    PaginationListCell()
//}
