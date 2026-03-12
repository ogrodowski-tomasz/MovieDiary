import Foundation
import Nuke

public enum ImagePipelineProvider {
    public static let shared: ImagePipeline = {
       let dataCache = try? DataCache(name: "image_cache")
        
        let imageCache = ImageCache(costLimit: 200 * 1024 * 1024)
        imageCache.countLimit = 200
        
        var config = ImagePipeline.Configuration()
        config.dataCache = dataCache
        config.imageCache = imageCache
        config.dataLoader = DataLoader()
        config.isProgressiveDecodingEnabled = true
        config.dataCachePolicy = .automatic
        
        return ImagePipeline(configuration: config)
    }()
}
