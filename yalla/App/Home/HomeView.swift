//
//  HomeView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 15/10/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core

struct HomeView: View {
    @StateObject
    var viewModel: HomeViewModel = .init()
    
    @StateObject
    private var navigator: Navigator = .init()
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            ZStack {
                if let map = viewModel.map {
                    HomeMapView(viewModel: map)
                        .environmentObject(viewModel)
                }
                
                innerBody
                
                if let sheetModel = viewModel.sheetModel {
                    HomeIdelBottomSheet(viewModel: sheetModel, homeModel: self.viewModel)
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                route.scene
                    .environmentObject(navigator)
            }
            .navigationDestination(for: SideMenuRoute.self) { route in
                route.scene
                    .environmentObject(navigator)
            }
            .appSheet(isPresented: $viewModel.loginRequiredAlert) { authRequiredSheet }
        }
        .onAppear {
            Task { @MainActor in
                await viewModel.onAppear()
                await viewModel.setNavigator(navigator)
            }
        }
    }
    
    var innerBody: some View {
        VStack {
            HomeHeaderView(onClickMenu: {
                Task { @MainActor in
                    await viewModel.showMenu()
                }
            })
            .padding(.horizontal, AppParams.Padding.default)
            
            Spacer()
        }
    }
}

extension HomeView {
    
}

#Preview {
    HomeView()
}
