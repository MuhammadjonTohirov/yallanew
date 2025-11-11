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

actor HomeViewModel: ObservableObject {
    var navigator: Navigator?
    @MainActor
    @Published
    private(set) var map: HomeMapViewModel?
    
    @Published
    @MainActor
    private(set) var sheetModel: HomeIdleSheetViewModel?
    
    private(set) var interactor: any HomeInteractorProtocol
    
    init(interactor: any HomeInteractorProtocol = HomeInteractorFactory.create()) {
        self.interactor = interactor
    }
    
    @MainActor
    @Published var loginRequiredAlert: Bool = false
    
    func setNavigator(_ navigator: Navigator) {
        self.navigator = navigator
    }
    
    func onAppear() {
        
        Task { @MainActor in
            self.sheetModel = .init()
            self.map = .init()
        }
        
        self.syncPrerequisitesIfNeeded()
    }
}

extension HomeViewModel {
    // MARK: - Actions
    
    func showMenu() async {
        guard await interactor.hasUser() else {
            await showLoginRequiredAlert()
            return
        }
        
        guard let navigator else { return }

        Task { @MainActor in
            let menuViewModel = SideMenuViewModel()
            menuViewModel.setNavigator(navigator)
            navigator.push(HomeRoute.menu(model: menuViewModel))
        }
    }
    
    func onClickFromLocation() async {
        guard await interactor.hasUser() else {
            await showLoginRequiredAlert()
            return
        }
        
        // TODO: - handle on click from location
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
