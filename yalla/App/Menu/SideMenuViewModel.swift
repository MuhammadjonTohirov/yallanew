//
//  SideMenuViewModel.swift
//  Ildam
//
//  Created by applebro on 15/12/23.
//

import Foundation
import IldamSDK
import Core
import Combine
import YallaUtils

enum SideMenuType: String {
    case history = "history"
    case places = "places"
    case bonuses = "bonuses"
    case paymentMethods = "paymentMethods"
    case invite = "invite"
    case driver = "becomeDriver"
    case contactus = "contactUs"
    case settings = "settings"
    case aboutus = "about"
    case profile = "profile"
    case notification = "notification"
}

enum PaymentType {
    case cash
    case card
}

protocol SideMenuBodyProtocol: ObservableObject {
    var userInfo: UserInfo? {get}
}

actor SideMenuViewModel: SideMenuBodyProtocol {
    @MainActor
    private var observer: NSObjectProtocol?
    
    @MainActor
    private var navigator: Navigator?
    
    @MainActor
    @Published var userInfo: UserInfo?
    
    @MainActor
    @Published var bonus: Float = 0
    
    @MainActor
    var bonusValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "uz_UZ")
        formatter.maximumFractionDigits = 0
        formatter.decimalSeparator = ""
        formatter.currencySymbol = ""
        let bonusVal = formatter.string(from: NSNumber(value: bonus)) ?? ""
        return "you.have.n.cashback".localize(arguments: bonusVal)
    }

    // make it true to make discount and bonuses visible
    @MainActor
    var isDiscountVisible: Bool = true
    
    @MainActor
    var paymentMethod: String = {
        SyncCardsUseCaseImpl.shared.paymentTypeString
    }()
    
    @Published var paymentType: PaymentType = .cash

    @MainActor
    func setNavigator(_ navigator: Navigator) {
        self.navigator = navigator
    }
    
    @MainActor
    func onClick(menu type: SideMenuType) {
        guard let navigator = navigator else { 
            Logging.l(tag: "SideMenuViewModel", "Navigator not set")
            return 
        }
        
        // Convert SideMenuType to HomePushableRoute
        guard let route = HomePushableRoute.create(fromMenu: type) else {
            Logging.l(tag: "SideMenuViewModel", "No route found for menu type: \(type)")
            return
        }
        
        navigator.push(route)
        Logging.l(tag: "SideMenuViewModel", "Navigating to: \(type.rawValue)")
    }
     
    @MainActor
    func onAppear() async {
        await setupUserInfoChangeObserver()
        loadBonusValue()
        await subscribeConfigChange()
    }

    func onDisappear() {
//        TaxiOrderConfigProvider.shared.removeListener(self)
    }

    private func subscribeConfigChange() {
//        TaxiOrderConfigProvider.shared.addListener(self)
    }

    @MainActor
    private func loadBonusValue() {
        bonus = UserSettings.shared.userInfo?.balance ?? 0
    }
    
    @MainActor
    private func setupUserInfoChangeObserver() async {
        removeUserInfoChangeObserver()
        Logging.l(tag: "SideMenuViewModel", #function)
        observer = NotificationCenter.default.addObserver(forName: .userInfoChanged, object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in
                await self?.setUserInfo(UserSettings.shared.userInfo)
                self?.bonus = self?.userInfo?.balance ?? 0
                Logging.l(tag: "SideMenuViewModel", "\(#function) update")
            }
        }
    }
    
    @MainActor
    private func setUserInfo(_ userInfo: UserInfo?) async {
        self.userInfo = userInfo
    }
    
    @MainActor
    private func removeUserInfoChangeObserver() {
        if let observer {
            Logging.l(tag: "SideMenuViewModel", #function)
            NotificationCenter.default.removeObserver(observer)
        }
 
    }
    
    deinit {
//        removeUserInfoChangeObserver()
    }
}

extension NSNotification.Name {
    static let userInfoChanged = NSNotification.Name("UserInfoChanged")
}

//extension SideMenuViewModel: TaxiOrderConfigProviderDelegate {
//    @MainActor
//    private func reloadPaymentType() {
//        let isCash =  (TaxiOrderConfigProvider.shared.config.paymentTypeConfig?.paymentType ?? "cash") == "cash"
//        let cardId = TaxiOrderConfigProvider.shared.config.paymentTypeConfig?.paymentType
//        let cardType = CardType(cardId: cardId ?? "cash")
//        
//        self.paymentMethod = SyncCardsUseCaseImpl.shared.paymentTypeString
//        
//        if isCash {
//            paymentType = .cash
//        } else {
//            paymentType = cardType == .uzcard ? .card : .humo
//        }
//    }
//    
//    func didUpdateConfig(_ order: TaxiOrderConfig) {
//        Task { @MainActor in
//            self.reloadPaymentType()
//        }
//    }
//}
