import SwiftUI
import ReusableComponents
import EnvObjects
import Models

internal struct DetailsHeaderView: View {
    
    @Environment(CommonDataStore.self) var commonDataStore
    
    let model: MovieDetailsModel
    
    internal init(model: MovieDetailsModel) {
        self.model = model
    }
    
    internal var body: some View {
        ZStack(alignment: .bottom) {
            BackdropImageView(
                config: .init(
                    url: commonDataStore.configuration?.images.poster(for: model.posterPath, original: true),
                    height: 200,
                    cornerRadius: 0
                )
            )
            LinearGradient(
                colors: [
                    Color(uiColor: .secondarySystemGroupedBackground),
                    .clear,
                    .clear
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            VStack {
                Text(model.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .bold()
                Text(model.genres.join())
            }
            .frame(maxWidth: .infinity)
        }
    }
}

//#Preview {
//    DetailsHeaderView()
//}
