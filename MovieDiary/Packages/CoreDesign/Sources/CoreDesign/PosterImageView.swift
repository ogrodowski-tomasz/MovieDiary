import SwiftUI
import Nuke
import NukeUI

public struct PosterImageView: View {
    let config: ImageConfig
    
    public init(config: ImageConfig) {
        self.config = config
    }
    
    public var body: some View {
        LazyImage(request: .init(url: config.url, processors: [.resize(size: config.size)])) { state in
//            logType(state)
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: config.width, height: config.height)
                    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
            } else {
                #warning("Improve. Make config a aspectRatio with width instead of width/height")
                RoundedRectangle(cornerRadius: config.cornerRadius)
                    .fill(.thinMaterial)
                    .overlay(alignment: .center) {
                        if state.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "film")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: config.width, height: config.height)
            }
        }
        .pipeline(ImagePipeline.shared)
    }
    
    private func logType(_ state: any LazyImageState) -> some View {
        switch state.result {
        case .success(let success):
            switch success.cacheType {
            case .disk:
                print("DEBUG: DISK CACHE")
            case .memory:
                print("DEBUG: MEMORY CACHE")
            case .none:
                print("DEBUG: NO CACHE")
            }
        case .failure(let failure):
            print("DEBUG: NO IMAGE")
        case .none:
            print("DEBUG: NONE STATE")
        }
        return EmptyView()
    }
}

#Preview {
    HStack {
        PosterImageView(config: .sample1)
        PosterImageView(config: .sample2)
        PosterImageView(config: .sample3)
    }
}
