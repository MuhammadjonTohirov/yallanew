//
//  AppDestination.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import SwiftUI

protocol ScreenRoute: Hashable, Identifiable {
    associatedtype Content: View
    var screen: Content {get}
    
    var id: String {get}
}

enum AppDestination: Hashable, @MainActor ScreenRoute {
    static func == (lhs: AppDestination, rhs: AppDestination) -> Bool {
        lhs.id == rhs.id
    }

    var id: String {
        "\(self)"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case intro
    case auth
    case main
    case home
    case language
    case loading
    case pin
    case permissions
    case notificationRequest
    case locationRequest
    case test
    
    @ViewBuilder var screen: some View {
        switch self {
        case .loading:
            InitialLoadingView()
        case .home:
            HomeView()
        case .language:
            SelectLanguageView()
        case .permissions:
            PermissionsView()
        case .auth:
            LoginView()
        default:
            EmptyView()
        }
    }
}
