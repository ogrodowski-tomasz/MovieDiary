import Foundation
import OSLog

public enum AppTab: Hashable, CaseIterable {
    case main
    case profile
    
    public var title: String {
        switch self {
        case .main:
            return "Main"
        case .profile:
            return "Profile"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .profile:
            "person"
        case .main:
            "plus"
        }
    }
}

@MainActor
@Observable
public final class Router {
    public var mainPath: [RouteDestination] = []
    public var profilePath: [RouteDestination] = []
    
    public var selectedTab: AppTab = .main
    
//    private let logger = Logger(category: "Router")
    
    public init() {
        
    }
    
    public func push(to route: RouteDestination) {
        switch selectedTab {
        case .main:
            mainPath.append(route)
        case .profile:
            profilePath.append(route)
        }
    }
    
    @discardableResult
    public func pop() -> RouteDestination? {
        switch selectedTab {
        case .main:
            return mainPath.popLast()
        case .profile:
            return profilePath.popLast()
        }
    }
    
    public func popToRoot() {
        switch selectedTab {
        case .main:
            mainPath.removeAll()
        case .profile:
            profilePath.removeAll()
        }
    }
}
