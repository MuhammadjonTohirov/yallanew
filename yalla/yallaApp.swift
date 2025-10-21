//
//  yallaApp.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/10/25.
//

import SwiftUI
import UIKit
import Core
import Firebase
import IldamSDK

@main
struct yallaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(ApplicationDelegate.self) var delegate
    
    let viewModel = MainViewModel(route: .loading)
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
                .onAppear {
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
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                UserSettings.shared.lastActiveDate = Date()
            }
        }
    }
}

class ApplicationDelegate: UIResponder, UIApplicationDelegate, FirebaseMessaging.MessagingDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        UserSettings.shared.fcmToken = fcmToken
        Task {
            await SyncFCMUseCaseImpl().syncFCMtoken()
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (
            UIBackgroundFetchResult
        ) -> Void
    ) {
        debugPrint("RemoteNotification", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension ApplicationDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint(
            "RemoteNotification",
            "Received Notification: \(notification.request.content.userInfo)"
        )
    }
}
