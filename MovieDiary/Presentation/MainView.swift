import SwiftUI
import Models
import EnvObjects
import ListUI

struct MainView: View {
    @Environment(UserSessionStore.self) var userSessionStore

    @Environment(ListDataStore.self) var dataStore

    @State private var viewDidAppear: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, content: {
                LazyVStack(alignment: .leading, spacing: 0) {
                    if dataStore.popularMoviesState.showData {
                        Text("Popular Movies")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        CarouselListView(items: dataStore.popularMoviesState.abbreviatedList, showMore: dataStore.popularMoviesState.showMoreVisible)
                    }

                    if dataStore.popularTvState.showData {
                        Text("Popular TV")
                            .padding(.top)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        CarouselListView(items: dataStore.popularTvState.abbreviatedList, showMore: dataStore.popularTvState.showMoreVisible)
                    }

                    if dataStore.topRatedMoviesState.showData {
                        Text("Top Rated Movies")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        CarouselListView(items: dataStore.topRatedMoviesState.abbreviatedList, showMore: dataStore.topRatedMoviesState.showMoreVisible)
                    }

                    if dataStore.topRatedTvState.showData {
                        Text("Top Rated TV")
                            .padding(.top)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        CarouselListView(items: dataStore.topRatedTvState.abbreviatedList, showMore: dataStore.topRatedTvState.showMoreVisible)
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
            viewDidAppear = true
        }
    }
}

#Preview {
    MainView()
}
