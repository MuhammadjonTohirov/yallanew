//
//  yallaApp.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/10/25.
//

import SwiftUI
import UIKit
import Core
import YallaUtils
import Firebase
import IldamSDK

@main
struct yallaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(ApplicationDelegate.self) var delegate
    @StateObject private var settingsStore: SettingsStore = .shared
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme
    
    let viewModel = MainViewModel(route: .loading)
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
                .onAppear {
                    settingsStore.setup()
                    Task {
                        await Crashlytics.crashlytics().checkForUnsentReports()
                    }
                    debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
                }
                .onOpenURL { url in
                    Task { @MainActor in
                        await DeepLinkManager.shared.handleDeepLink(url: url)
                        await DeepLinkManager.shared.handleDeepLinkAnalytics(url)
                    }
                }
                .withGlobalPopupAlert()
                .preferredColorScheme(
                    .init(.init(rawValue: settingsStore.theme) ?? UIUserInterfaceStyle.unspecified)
                )
                .onChange(of: colorScheme) { newValue in
                    debugPrint("Color scheme changed to \(newValue == .dark ? "dark" : "light")")
                    YallaUtils.YallaAlertManager.shared.colorScheme = newValue == .dark ? .dark : .light
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                UserSettings.shared.lastActiveDate = Date()
            }
        }
    }
}
