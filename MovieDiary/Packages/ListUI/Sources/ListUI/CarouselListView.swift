import Models
import EnvObjects
import NetworkClient
import SwiftUI

public protocol CarouselModel: Identifiable {
    var posterPath: String { get }
    var title: String { get }
    var id: Int { get }
}

extension MovieModel: CarouselModel {}
extension TvModel: CarouselModel {}

public struct CarouselListView<Item: CarouselModel>: View {
    let title: LocalizedStringResource
    let items: [Item]
    let showMore: Bool

    public init(title: LocalizedStringResource, items: [Item], showMore: Bool) {
        self.title = title
        self.items = items
        self.showMore = showMore
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 12) {
                    ForEach(items) { item in
                        CarouselCell(item: item)
                    }

                    if showMore {
                        Button {

                        } label: {
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.primary)
                                .padding()
                                .background(Color.yellow)
                                .clipShape(.circle)
                        }
                    }

                }
                .padding(.horizontal)
                .frame(minHeight: 250)
            }
        }
    }
}

private struct CarouselCell<Item: CarouselModel>: View {
    @Environment(CommonDataStore.self) var commonDataStore

    var config: Images? {
        commonDataStore.configuration?.images
    }

    let item: Item

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            AsyncImage(url: config?.poster(for: item.posterPath)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "film")
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 120, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(item.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 120, alignment: .center)
        }
    }
}

private struct CarouselPreviewWrapper: View {

    @State private var commonDataStore: CommonDataStore

    init() {
        _commonDataStore = State(initialValue: .init(commonNetworkManager: CommonNetworkManager(client: HTTPClient())))
        commonDataStore.configuration = .sample
    }

    var body: some View {
        CarouselListView(title: "Top Rated", items: MovieModel.sampleList, showMore: true)
            .environment(commonDataStore)
    }
}

#Preview {
    CarouselPreviewWrapper()
}
