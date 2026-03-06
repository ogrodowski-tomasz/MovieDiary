import SwiftUI
import Models

struct MainView: View {
    @Environment(UserSessionStore.self) var userSessionStore

    @Environment(ListDataStore.self) var dataStore

    @State private var viewDidAppear: Bool = false

    var body: some View {
        NavigationStack {
            List {
                if dataStore.popularMoviesState.showData {

                    Section("Movies") {
                        ForEach(dataStore.popularMoviesState.abbreviatedList) { movie in
                            NavigationLink(movie.title, destination: Text(movie.overview))
                        }
                        if dataStore.popularMoviesState.showMoreVisible {
                            Button("Show more", systemImage: "chevron.right") {

                            }
                        }
                    }
                }

                if dataStore.popularMoviesState.showData {
                    Section("TV Shows") {
                        ForEach(dataStore.popularTvState.abbreviatedList) { show in
                            NavigationLink(show.name ?? "missing", destination: Text(show.overview ?? "missing"))
                        }
                        if dataStore.popularTvState.showMoreVisible {
                            Button("Show more", systemImage: "chevron.right") {

                            }
                        }
                    }
                }
            }
            .navigationTitle("List")
        }
        .task {
            guard !viewDidAppear else { return }
            await dataStore.fetchPopular()
            viewDidAppear = true
        }
    }
}

#Preview {
    MainView()
}
