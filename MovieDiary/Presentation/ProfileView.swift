import CoreNetwork
import CoreEnvironment
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
                        Text(verbatim: user.name)
                            .font(.largeTitle)
                    }
                }
                
                Text(verbatim: "Rated Movies (\(rated.totalResults))")
                ForEach(rated.results) { movie in
                    Text(verbatim: movie.title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
        }
    }
}
