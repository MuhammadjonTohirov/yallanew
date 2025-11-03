//
//  SideMenuViewModel.swift
//  Ildam
//
//  Created by applebro on 15/12/23.
//

import Foundation
import IldamSDK
import Core
@preconcurrency import Combine
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
    var userInfo: UserInfo? {get async}
}

final class SideMenuViewModel: SideMenuBodyProtocol {
    
    private var navigator: Navigator?
    
    @Published
    var userInfo: UserInfo?
    
    var imageUrl: URL? {
        userInfo?.imageURL
    }
    
    var fullName: String {
        userInfo?.fullName ?? ""
    }
    
    var bonus: Float {
        userInfo?.balance ?? 0
    }
    
    var bonusValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "uz_UZ")
        formatter.maximumFractionDigits = 0
        formatter.decimalSeparator = ""
        formatter.currencySymbol = ""
        let bonusVal = formatter.string(from: NSNumber(value: bonus)) ?? ""
        return bonusVal
    }
    
    var bonusDescription: String {
        return "you.have.n.cashback".localize(arguments: bonusValue)
    }

    // make it true to make discount and bonuses visible
    var isDiscountVisible: Bool = true
    
    var paymentMethod: String = {
        SyncCardsUseCaseImpl.shared.paymentTypeString
    }()
    
    @Published var paymentType: PaymentType = .cash
    
    private(set) var userInfoChangeCancellable: AnyCancellable?

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
        guard let route = SideMenuRoute.create(fromMenu: type) else {
            Logging.l(tag: "SideMenuViewModel", "No route found for menu type: \(type)")
            return
        }
        
        navigator.push(route)
        Logging.l(tag: "SideMenuViewModel", "Navigating to: \(type.rawValue)")
    }
    
    func onAppear() {
        Task.detached(priority: .high) { [weak self] in
            guard let self else { return }
            async let task1: () = setUserInfo(UserSettings.shared.userInfo)
            async let task2: () = setupUserInfoChangeObserver()
            async let task3: () = subscribeConfigChange()
            
            _ = await [task1, task2, task3]
        }
    }

    func onDisappear() {
        removeUserInfoChangeObserver()
    }

    private func subscribeConfigChange() async {
        await TaxiOrderConfigProvider.shared.addListener(self)
    }
    
    private func setupUserInfoChangeObserver() async {
        do {
            let info = try await MeInfoProvider.shared.syncUserInfo()
            setUserInfo(info)
        } catch {}
    }
    
    @MainActor
    private func setUserInfo(_ userInfo: UserInfo?) {
        withAnimation {
            self.userInfo = userInfo
        }
    }
    
    private func removeUserInfoChangeObserver() {
        if let userInfoChangeCancellable {
            userInfoChangeCancellable.cancel()
        }
    }
    
    deinit {
        debugPrint("Deinit side menu view model")
    }
}

extension SideMenuViewModel: TaxiOrderConfigProviderDelegate {
    @MainActor
    private func reloadPaymentType() {
        
    }
    
    nonisolated func didUpdateConfig(_ order: TaxiOrderConfig) {

    }
}
