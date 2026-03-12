import Foundation

public struct ImageConfig: Sendable {
    
    public let url: URL?
    public let width: CGFloat
    public let height: CGFloat
    
    public var size: CGSize {
        .init(width: width, height: height)
    }
    
    public let cornerRadius: CGFloat
    
    public init(url: URL?, width: CGFloat = 0, height: CGFloat = 0, cornerRadius: CGFloat = 0) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    internal static let sample1 = Self.init(url: .init(string: "https://image.tmdb.org/t/p/w154/ckQzKpQJO4ZQDCN5evdpKcfm7Ys.jpg"), width: 120, height: 180, cornerRadius: 8)
    internal static let sample2 = Self.init(url: .init(string: "https://image.tmdb.org/t/p/w500/saHP97rTPS5eLmrLQEcANmKrsFl.jpg"), width: 120, height: 180, cornerRadius: 25)
    internal static let sample3 = Self.init(url: .init(string: "https://image.tmdb.org/t/p/w500/u40gJarLPlIkwouKlzGdobQOV9k.jpg"), width: 120, height: 180, cornerRadius: 0)
    
    internal static let brokenSample = Self.init(url: .init(string: "xxxxxx"), width: 120, height: 180, cornerRadius: 0)
    
    internal static let backgdropSample1 = Self.init(url: .init(string: "https://image.tmdb.org/t/p/w780/7Zx3wDG5bBtcfk8lcnCWDOLM4Y4.jpg"), width: 120, height: 250, cornerRadius: 8)
}
