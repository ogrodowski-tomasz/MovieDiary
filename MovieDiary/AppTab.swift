//
//  AppTab.swift
//  MovieDiary
//
//  Created by itcraft on 25/02/2026.
//


import SwiftUI

enum AppTab: Hashable {
    case profile
    case main
    
    static var tabs: [AppTab] {
        [.main, .profile]
    }
    
    var title: String {
        switch self {
        case .main:
            return "Main"
        case .profile:
            return "Profile"
        }
    }
    
    var systemImage: String {
        switch self {
        case .profile:
            "person"
        case .main:
            "plus"
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .main:
            MainView()
        case .profile:
            LoginView()
        }
    }
}
