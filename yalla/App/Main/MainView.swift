//
//  MainView.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import SwiftUI
import NetworkMonitor
import Core

var networkMonitor: NetworkMonitor = .init(
    serverUrl: "https://yalla.uz",
    delegate: nil
)

struct MainView: View {
    @StateObject var viewModel = MainViewModel(route: .loading)
    @Environment(\.scenePhase)
    var scenePhase
    
    var body: some View {
        ZStack {
            viewModel.route.screen
        }
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(true)
        .environmentObject(viewModel)
        .onChange(of: networkMonitor.state) { value in
            if value == .connected {
                viewModel.presentNetworkFailure = false
            } else if value == .disconnected {
                viewModel.presentNetworkFailure = true
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willEnterForegroundNotification
            )
        ) { _ in
            #if DEBUG
            debugPrint("App has entered the foreground")
            #endif
            networkMonitor.startMonitoring()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didEnterBackgroundNotification
            )
        ) { _ in
            #if DEBUG
            debugPrint("App has entered the background")
            #endif
            networkMonitor.stopMonitoring()
        }
        .onAppear {
            setupNavigationBar()
            mainModel = viewModel
            networkMonitor.delegate = viewModel
            networkMonitor.startMonitoring()
        }
        .onDisappear {
            networkMonitor.stopMonitoring()
        }
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        if #available(iOS 26.0, *) {
            
        } else {
            appearance.configureWithOpaqueBackground()
        }
        
        let app = UIBarButtonItemAppearance()
        app.normal.backgroundImage = UIImage(named: "icon_back_round")
        app.normal.backgroundImagePositionAdjustment = .init(horizontal: 0, vertical: 0)
        
        let back = UIBarButtonItemAppearance(style: .done)
        back.normal.backgroundImage = UIImage()
        back.normal.backgroundImagePositionAdjustment = .init(horizontal: 100, vertical: 0)
        back.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        appearance.buttonAppearance = app
        appearance.backButtonAppearance = back
        
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        
        appearance.largeTitleTextAttributes = atters
//        appearance.titleTextAttributes = atters
        
        // if iOS26 use icon_back
        if #available(iOS 26.0, *) {
            appearance.setBackIndicatorImage(
                UIImage(named: "icon_back_smaller")?.withRenderingMode(.alwaysTemplate),
                transitionMaskImage: UIImage(named: "icon_back_smaller")?.withRenderingMode(.alwaysTemplate)
            )
        } else {
            appearance.setBackIndicatorImage(
                UIImage(
                    named: "icon_back"
                )?.withRenderingMode(.alwaysOriginal),
                
                transitionMaskImage: UIImage(
                    named: "icon_back"
                )?.withRenderingMode(.alwaysOriginal)
            )
            return
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance // Add this for iOS 15+
        
        // For complete removal of back button text for all view controllers
        UIBarButtonItem.appearance()
            .setBackButtonTitlePositionAdjustment(
                UIOffset(horizontal: -1000, vertical: 0),
                for: .default
        )
        
        UserSettings.shared.set(
            interfaceStyle: UserSettings.shared.theme?.style ?? .unspecified
        )
    }
}

#Preview {
    MainView()
}
