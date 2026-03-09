import Models
import EnvObjects
import NetworkClient
import SwiftUI
import Nuke

public struct CarouselListView: View {
    @Environment(Router.self) var router

    let title: LocalizedStringResource
    let items: [ListModel]
    let showMore: Bool

    public init(title: LocalizedStringResource, items: [ListModel], showMore: Bool) {
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
                            router.push(to: .showFull)
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

private struct CarouselPreviewWrapper: View {

    @State private var commonDataStore: CommonDataStore

    init() {
        _commonDataStore = State(initialValue: .init())
        commonDataStore.configuration = .sample
    }

    var body: some View {
        VStack {
            CarouselListView(title: "Top Rated", items: [.sample(.movies)], showMore: true)
            CarouselListView(title: "Popular", items: [.sample(.tvShows)], showMore: true)
        }
        .environment(commonDataStore)
    }
}

#Preview {
    CarouselPreviewWrapper()
}
