import SwiftUI
import Models
import EnvObjects
import ListUI

struct MainView: View {
    enum ListType: Hashable, CaseIterable {
        case movies
        case tvShows

        var title: String {
            switch self {
            case .movies:
                "Movies"
            case .tvShows:
                "TV Shows"
            }
        }
    }
    @Environment(UserSessionStore.self) var userSessionStore

    @Environment(ListDataStore.self) var dataStore

    @State private var viewDidAppear: Bool = false

    @State private var selectedList: ListType = .movies

    var body: some View {
        NavigationStack {
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
                        Group {
                            if dataStore.popularMoviesState.showData {
                                CarouselListView(title: dataStore.popularMoviesState.title, items: dataStore.popularMoviesState.abbreviatedList, showMore: dataStore.popularMoviesState.showMoreVisible)
                            }

                            if dataStore.upcomingMoviesState.showData {
                                CarouselListView(title: dataStore.upcomingMoviesState.title, items: dataStore.upcomingMoviesState.abbreviatedList, showMore: dataStore.upcomingMoviesState.showMoreVisible)
                            }

                            if dataStore.topRatedMoviesState.showData {
                                CarouselListView(title: dataStore.topRatedMoviesState.title, items: dataStore.topRatedMoviesState.abbreviatedList, showMore: dataStore.topRatedMoviesState.showMoreVisible)
                            }
                        }
                    case .tvShows:
                        Group {
                            if dataStore.popularTvState.showData {
                                CarouselListView(title: dataStore.popularTvState.title, items: dataStore.popularTvState.abbreviatedList, showMore: dataStore.popularTvState.showMoreVisible)
                            }

                            if dataStore.airingTodayTvState.showData {
                                CarouselListView(title: dataStore.airingTodayTvState.title, items: dataStore.airingTodayTvState.abbreviatedList, showMore: dataStore.airingTodayTvState.showMoreVisible)
                            }

                            if dataStore.topRatedTvState.showData {
                                CarouselListView(title: dataStore.topRatedTvState.title, items: dataStore.topRatedTvState.abbreviatedList, showMore: dataStore.topRatedTvState.showMoreVisible)
                            }
                        }
                    }
                }
            })

            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            guard !viewDidAppear else { return }
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
