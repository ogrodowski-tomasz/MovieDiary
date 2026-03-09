import Models
import EnvObjects
import NetworkClient
import SwiftUI
import Nuke

public struct CarouselListView: View {
    public enum CarouselType {
        case posters([ListModel])
        case profiles([CastCrewModel])
        
        var height: CGFloat {
            switch self {
            case .posters: 250
            case .profiles: 200
            }
        }
    }
    
    @Environment(Router.self) var router

    let title: LocalizedStringResource
    let type: CarouselType
    let showMore: Bool

    public init(title: LocalizedStringResource, type: CarouselType, showMore: Bool) {
        self.title = title
        self.type = type
        self.showMore = showMore
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 12) {
                    switch type {
                    case let .posters(items):
                        ForEach(items) { item in
                            CarouselCell(item: item)
                        }
                    case let .profiles(items):
                        ForEach(items) { item in
                            CastCarouselCell(item: item)
                        }
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
                .frame(height: type.height)
            }
            Spacer()
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
            Rectangle()
            CarouselListView(title: "Top rated", type: .posters([.sample(.movies)]), showMore: false)
                
            CarouselListView(title: "Cast", type: .profiles([.sample]), showMore: false)
            Rectangle()
            Rectangle()
            Rectangle()
        }
        .environment(commonDataStore)
        .environment(Router())
    }
}

#Preview {
    CarouselPreviewWrapper()
}
