import SwiftUI
import ReusableComponents
import EnvObjects
import Models

public struct DetailsHeaderView: View {
    
    @Environment(CommonDataStore.self) var commonDataStore
    @Environment(UserSessionStore.self) var userSessionStore
    
    public let viewModel: DetailsViewModel
        
    public init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            BackdropImageView(
                config: .init(
                    url: commonDataStore.configuration?.images.poster(for: viewModel.posterPath, original: true),
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
                Text(viewModel.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .bold()
                Text(viewModel.genres ?? "")
                    .redactWithPlaceholder(when: viewModel.genres == nil)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    
}
