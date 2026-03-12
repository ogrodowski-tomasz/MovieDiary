import CoreEnvironment
import SwiftUI

public struct LanguagesListView: View {
    
    @Environment(UserPreferences.self) var userPreferences
    
    let list: [AppLanguages]
    let current: AppLanguages
    let locale: AppLanguages?
    
    @State private var selected: AppLanguages? = nil
    
    public init(list: [AppLanguages], current: String) {
        let currentLang = list.resolve(for: current)
        let excluding = list.excluding(currentLang)
        let localeIdentifier = Locale.current.language.languageCode?.identifier
        self.locale = list.resolve(for: localeIdentifier)
        self.current = currentLang
        self.list = excluding
    }
    
    public var body: some View {
        List {
            Section("Current") {
                LabeledContent {
                    Text(verbatim: current.name.isEmpty ? current.english_name : current.name)
                } label: {
                    LabeledContent(current.english_name, value: current.flagEmoji)
                }
            }
            if let locale, locale != current {
                Section("Locale") {
                    Button {
                        selected = locale
                    } label: {
                        LabeledContent {
                            Text(verbatim: locale.name.isEmpty ? locale.english_name : locale.name)
                        } label: {
                            LabeledContent(locale.english_name, value: locale.flagEmoji)
                        }
                    }
                }
            }
            Section {
                ForEach(list, id: \.self) { item in
                    Button {
                        // Present alert
                        selected = item
                    } label: {
                        LabeledContent {
                            Text(verbatim: item.name.isEmpty ? item.english_name : item.name)
                        } label: {
                            Text(verbatim: item.english_name)
                        }
                    }
                }
            }
        }
        .alert("Are you sure?", isPresented: .init(get: {
            selected != nil
        }, set: { _ in
            selected = nil
        }), actions: {
            Button(role: .cancel, action: {})
            Button(role: .confirm, action: changeLanguage)
                .keyboardShortcut(.defaultAction)
        }, message: {
            Text("Confirm changing language to\n\(selected?.english_name ?? "-")")
        })
    }
    
    private func changeLanguage() {
        guard let selected else { return }
        userPreferences.appLanguage = selected.iso_639_1
    }
}
//
//#Preview {
//    LanguagesListView()
//}
