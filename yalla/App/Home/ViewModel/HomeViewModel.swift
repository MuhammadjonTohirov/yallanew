//
//  HomeViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 15/10/25.
//

import Foundation
import Combine
import YallaUtils
import Core
import MapPack

final class HomeViewModel: ObservableObject {
    var navigator: Navigator?
    
    @MainActor
    @Published
    private(set) var map: HomeMapViewModel?
    
    @Published
    var showAddressPicker: Bool = false
    
    private(set) var sheetModel: HomeIdleSheetViewModel?
    
    var selectAddressViewModel: SelectAddressViewModel?
    
    private(set) var interactor: any HomeInteractorProtocol
    
    private var didAppear: Bool = false
    
    init(interactor: any HomeInteractorProtocol = HomeInteractorFactory.create()) {
        self.interactor = interactor
    }
    
    @MainActor
    @Published var loginRequiredAlert: Bool = false
    
    func setNavigator(_ navigator: Navigator) {
        self.navigator = navigator
    }
    
    func onAppear() {
        if didAppear { return }; didAppear = true
        Logging.l(tag: "HomeViewModel", "onAppear")
        Task { @MainActor in
            HomePropertiesHolder.shared.setup()
            self.sheetModel = .init()
            self.map = .init()
            self.map?.setDelegate(self)
        }
        
        self.syncPrerequisitesIfNeeded()
    }
}

extension HomeViewModel {
    // MARK: - Actions
    
    func showMenu() async {
        guard await interactor.hasUser() else {
            showLoginRequiredAlert()
            return
        }
        
        guard let navigator else { return }

        Task { @MainActor in
            let menuViewModel = SideMenuViewModel()
            menuViewModel.setNavigator(navigator)
            navigator.push(HomeRoute.menu(model: menuViewModel))
        }
    }
    
    @MainActor
    private func showLoginRequiredAlert() {
        loginRequiredAlert = true
    }
}

extension HomeViewModel {
    // MARK: Auth
    func showAuth() {
        let _navigator = navigator
        Task { @MainActor in
            loginRequiredAlert = false
            _navigator?.push(HomeRoute.auth)
        }
    }
}
