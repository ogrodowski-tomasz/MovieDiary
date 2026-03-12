import Foundation
import SwiftUI

@MainActor
@Observable
public class UserPreferences {
    
    class Storage {
        @AppStorage("app_language") public var appLanguage: String?
    }
    
//    public static let sharedDefault = UserDefaults(suiteName: "group.com.ogrodowskitomasz.movieDiary")
    public static let shared = UserPreferences()
    private let storage = Storage()
    
    public var appLanguage: String {
        didSet {
            storage.appLanguage = appLanguage
        }
    }
    
    private init() {
        let localeIdentifier = Locale.current.language.languageCode!.identifier
        print("Current locale: \(localeIdentifier)")
        appLanguage = storage.appLanguage ?? localeIdentifier
    }
    
}
