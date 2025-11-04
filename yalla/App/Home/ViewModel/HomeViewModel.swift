//
//  HomeViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 15/10/25.
//

import Foundation
import Combine
import YallaUtils
import SwiftUI

enum HomeRoute: SceneDestination {
    var id: String { "\(self)" }
    
    case menu(model: SideMenuViewModel)
    
    @MainActor
    var scene: some View {
        switch self {
        case .menu(let model):
            SideMenuBody(viewModel: model)
        }
    }
    
    static func ==(lhs: HomeRoute, rhs: HomeRoute) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

actor HomeViewModel: ObservableObject {
    @MainActor
    var navigator: Navigator?
    
    @MainActor
    func setNavigator(_ navigator: Navigator) {
        self.navigator = navigator
    }
    
    @MainActor
    func showMenu() {
        guard let navigator else { return }
        let menuViewModel = SideMenuViewModel()
        Task { @MainActor in
            await menuViewModel.setNavigator(navigator)
        }
        navigator.push(HomeRoute.menu(model: menuViewModel))
    }
}
