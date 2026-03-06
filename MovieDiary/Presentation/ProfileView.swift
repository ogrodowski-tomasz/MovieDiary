import NetworkClient
import Models
import SwiftUI

struct ProfileView: View {
    
    @Environment(CommonDataStore.self) var commonDataStore
    
    let user: TmdbUser
    let rated: UserRatedMovieListResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ProfileImageView(appConfiguration: commonDataStore.configuration, profilePath: user.avatar.tmdb.avatarPath)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(user.name)
                            .font(.largeTitle)
                    }
                }
                
                Text("Rated Movies (\(rated.totalResults))")
                ForEach(rated.results) { movie in
                    Text(movie.title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
        }
    }
}

struct ProfileViewWrapper: View {
    
    @State private var commonDataStore = CommonDataStore(
        commonNetworkManager: CommonNetworkManager(
            client: MockHTTPClient()
        )
    )
    
    var body: some View {
        NavigationStack {
            ProfileView(user: .empty, rated: .empty)
                .environment(commonDataStore)
                .task {
                    await commonDataStore.getConfiguration()
                }
        }
    }
}

#Preview {
    ProfileViewWrapper()
}
