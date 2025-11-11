//
//  HomeRoute.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import SwiftUI
import YallaUtils

enum HomeRoute: SceneDestination {
    var id: String { "\(self)" }
    
    case menu(model: SideMenuViewModel)
    case auth
    
    @ViewBuilder
    var scene: some View {
        switch self {
        case .menu(let model):
            SideMenuBody(viewModel: model)
        case .auth:
            LoginView()
        }
    }
    
    static func ==(lhs: HomeRoute, rhs: HomeRoute) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
