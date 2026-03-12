import CoreEnvironment
import SwiftUI
import Nuke

public enum CarouselListConfig {
    case paginableList(PaginationListMode)
    case castList([CastCrewModel], limiter: Int)
    
    var title: LocalizedStringResource {
        switch self {
        case let .paginableList(paginationListMode):
            return paginationListMode.title
        case .castList:
            return "section.title.cast"
        }
    }
    
    var showMoreActive: Bool {
        switch self {
        case let .paginableList(paginationListMode):
            return paginationListMode.showMoreActive
        case let .castList(cast, limiter):
            return cast.count > limiter
        }
    }
    
    var height: CGFloat {
        switch self {
        case let .paginableList(paginationListMode):
            return paginationListMode.carouselType.height
        case .castList:
            return 200
        }
    }
    
    var destination: RouteDestination {
        switch self {
        case let .paginableList(mode):
            return .paginatedList(mode)
        case let .castList(cast,_):
            return .castList(cast)
        }
    }
}

public struct CarouselListView: View {
    
    @Environment(Router.self) var router

    let config: CarouselListConfig

    public init(config: CarouselListConfig) {
        self.config = config
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                router.push(to: config.destination)
            } label: {
                HStack(alignment: .center, spacing: 8) {
                    Text(config.title)
                        .font(.largeTitle)
                    if config.showMoreActive {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                    }
                }
            }
            .disabled(!config.showMoreActive)
            .foregroundStyle(.primary)
            .fontWeight(.bold)
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 12) {
                    switch config {
                    case let .paginableList(mode):
                        ForEach(mode.initial.results) { item in
                            CarouselCell(item: item)
                        }
                    case let .castList(cast, limiter):
                        ForEach(cast.prefix(limiter)) { item in
                            CastCarouselCell(item: item)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: config.height)
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
