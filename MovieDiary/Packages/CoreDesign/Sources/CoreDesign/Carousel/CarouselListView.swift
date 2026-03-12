import CoreEnvironment
import SwiftUI
import Nuke

public struct CarouselListView: View {
    
    @Environment(Router.self) var router

    let paginableType: PaginationListMode

    public init(paginableType: PaginationListMode) {
        self.paginableType = paginableType
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                router.push(to: .paginatedList(paginableType))
            } label: {
                HStack(alignment: .center, spacing: 8) {
                    Text(paginableType.title)
                        .font(.largeTitle)
                    if paginableType.showMoreActive {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                    }
                }
            }
            .disabled(!paginableType.showMoreActive)
            .foregroundStyle(.primary)
            .fontWeight(.bold)
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 12) {
                    switch paginableType.carouselType {
                    case let .posters(items):
                        ForEach(items) { item in
                            CarouselCell(item: item)
                        }
                    case let .profiles(items):
                        ForEach(items) { item in
                            CastCarouselCell(item: item)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: paginableType.carouselType.height)
            }
            Spacer()
        }
    }
}
//
//private struct CarouselPreviewWrapper: View {
//
//    @State private var commonDataStore: CommonDataStore
//
//    init() {
//        _commonDataStore = State(initialValue: .init())
//        commonDataStore.configuration = .sample
//    }
//
//    var body: some View {
//        VStack {
//            Rectangle()
//            CarouselListView(paginableType: .topRated(type: .movies, initial: .ini), carouselType: <#T##CarouselListView.CarouselType#>, showMore: <#T##Bool#>)
//            CarouselListView(title: "Top rated", type: .posters([.sample(.movies)]), showMore: true)
//            CarouselListView(title: "Top rated", type: .posters([.sample(.movies)]), showMore: false)
//
////            CarouselListView(title: "Cast", type: .profiles([.sample]), showMore: false)
//            Rectangle()
//            Rectangle()
//            Rectangle()
//        }
//        .environment(commonDataStore)
//        .environment(Router())
//    }
//}
//
//#Preview {
//    CarouselPreviewWrapper()
//}
