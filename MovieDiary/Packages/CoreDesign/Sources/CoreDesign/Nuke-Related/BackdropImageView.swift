import SwiftUI
import NukeUI
import Nuke
import UIKit

public struct BackdropImageView: View {
    let config: ImageConfig
    
    public init(config: ImageConfig) {
        self.config = config
    }
    
    public var body: some View {
        LazyImage(request: .init(url: config.url, processors: [.resize(height: config.height)])) { state in
//            logType(state)
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFit()
                    .background(Color.red)
            } else {
                Rectangle()
                    
                    .fill(.blue)
                    .background(Color.red)
                    .overlay(alignment: .center) {
                        if state.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "film")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: config.height)
                    .background(Color.red)
            }
        }
        .pipeline(ImagePipeline.shared)
        .overlay {
            let colors: [Color] = [
//                Color(uiColor: .systemBackground),
                .clear,
                .clear,
                .clear
            ]
            LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
        }
        .background(Color.red)
    }
}

#Preview {
    BackdropImageView(config: .backgdropSample1)
}
