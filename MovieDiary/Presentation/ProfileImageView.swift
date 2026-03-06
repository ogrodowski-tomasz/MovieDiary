import Models
import SwiftUI

struct ProfileImageView: View {
    let appConfiguration: AppConfiguration?
    let profilePath: String
    
    var path: URL? {
        appConfiguration?.images.withPath(profilePath)
    }
    
    var body: some View  {
        AsyncImage(url: path) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .contentShape(.circle)
            case .empty:
                Rectangle()
            default:
                Rectangle().fill(Color.red)
            }
        }
        .background {
            Color.red.opacity(0.3)
        }
        .clipShape(.circle)
        .frame(width: 200, height: 200)
        .onAppear {
            print(path ?? "missing path")
        }
    }
}
