import SwiftUI
import Models
import EnvObjects

public struct MainView: View {
    @Environment(UserSessionStore.self) var userSessionStore
    @Environment(ListDataStore.self) var dataStore

    @Environment(\.httpClient) var client

    public init() { }

    @State private var viewDidAppear: Bool = false
    @State private var selectedList: ListType = .movies

    public var body: some View {
            Picker("Source", selection: $selectedList) {
                ForEach(ListType.allCases, id: \.self) { type in
                    Text(type.title)
                        .id(type as ListType)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 10)

            ScrollView(.vertical, content: {
                
                LazyVStack(alignment: .leading, spacing: 0) {
                    switch selectedList {
                    case .movies:
                        ForEach(dataStore.moviesSections) { section in
                            if section.showData {
                                CarouselListView(title: section.title, items: section.abbreviatedList, showMore: section.showMoreVisible)
                            }
                        }
                    case .tvShows:
                        ForEach(dataStore.tvShowsSections) { section in
                            if section.showData {
                                CarouselListView(title: section.title, items: section.abbreviatedList, showMore: section.showMoreVisible)
                            }
                        }
                    }
                }
            })
            .backMenuTitle("Main")
        .task {
            #warning("Improve")
            guard !viewDidAppear else { return }
            dataStore.injectClient(client)
            await dataStore.fetchPopular()
            await dataStore.fetchTopRated()
            await dataStore.fetchAiringTodayTvShows()
            await dataStore.fetchUpcomingMovies()
            viewDidAppear = true
        }
    }
}

#Preview {
    MainView()
}
