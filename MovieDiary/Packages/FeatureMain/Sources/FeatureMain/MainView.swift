import SwiftUI
import CoreDesign
import CoreEnvironment

public struct MainView: View {
    @Environment(UserSessionStore.self) var userSessionStore
    @Environment(UserPreferences.self) var userPreferences

    @Environment(\.httpClient) var client
    
    @State private var viewModel = ListViewModel()

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
                        ForEach(viewModel.viewState.moviesSections, id: \.self) { section in
                            CarouselListView(config: .paginableList(section))
                        }
                    case .tvShows:
                        ForEach(viewModel.viewState.tvShowsSections, id: \.self) { section in
                            CarouselListView(config: .paginableList(section))
                        }
                    }
                }
            })
            .backMenuTitle("Main")
        .task {
            guard !viewDidAppear else { return }
            viewModel.injectClient(client)
            await viewModel.fetchData(lang: userPreferences.appLanguage)
            viewDidAppear = true
        }
        .onChange(of: userPreferences.appLanguage, initial: false) { oldValue, newValue in
            guard oldValue != newValue else { return }
            Task {
                await viewModel.fetchData(lang: newValue)
            }
        }
    }
}

#Preview {
    MainView()
}
