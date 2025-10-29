//
//  HomePushableRoute.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 28/10/25.
//

import Foundation
import SwiftUI
import YallaUtils

enum HomePushableRoute: @MainActor SceneDestination {
    case history
    case places
    case bonuses
    case paymentMethods
    case invite
    case becomeDriver
    case contactUs
    case settings
    case about
    case profile
    case cancelOrderReason(_ completion: ((Int, String) -> Void))
//    case rideInfo(_ delegate: RideDetailsDelegate?)
    case notifications
    case custom(AnyView)

    var id: String {
        switch self {
        case .history:
            return "journey.history"
        case .places:
            return "places"
        case .bonuses:
            return "bonuses"
        case .paymentMethods:
            return "paymentMethods"
        case .invite:
            return "invite"
        case .becomeDriver:
            return "becomeDriver"
        case .contactUs:
            return "contactUs"
        case .settings:
            return "settings"
        case .about:
            return "about"
        case .profile:
            return "profile"
        case .cancelOrderReason:
            return "cancelOrder"
//        case .rideInfo:
//            return "rideInfo"
        case .notifications:
            return "notifications"
        case .custom:
            return "custom"
        }
    }
    
    static func create(fromMenu menu: SideMenuType) -> HomePushableRoute? {
        switch menu {
        case .history:
            return .history
        case .places:
            return .places
        case .bonuses:
            return .bonuses
        case .paymentMethods:
            return .paymentMethods
        case .invite:
            return .invite
        case .driver:
            return .becomeDriver
        case .contactus:
            return .contactUs
        case .settings:
            return .settings
        case .aboutus:
            return .about
        case .profile:
            return .profile
        case .notification:
            return .notifications
        }
    }
    
    @ViewBuilder
    var scene: some View {
        switch self {
        case .history:
            EmptyView()
//            TravelHistoryView()
//                .navigationBarTitleDisplayMode(.large)
        case .places:
//            MyPlacesView()
            EmptyView()
        case .about:
            AboutApplicationView()
        case .becomeDriver:
            BecomeDriverView()
        case .bonuses:
            BonusesView()
        case .paymentMethods:
            PaymentMethodsView()
        case .contactUs:
            ContactUsView()
        case .settings:
            SettingsView()
        case .invite:
            EmptyView()
//            InviteView()
        case .profile:
            EditProfileView()
        case .cancelOrderReason(let completion):
            EmptyView()
//            CancelOrder(completion: completion)
//        case .rideInfo(let delegate):
//            RideDetailsView(delegate: delegate)
        case .notifications:
            NotificationsView()
        case .custom(let view):
            view
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: HomePushableRoute, rhs: HomePushableRoute) -> Bool {
        lhs.id == rhs.id
    }
}
