//
//  ApplicationDelegate.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 05/11/25.
//

import Foundation
import UIKit
import FirebaseMessaging
import Firebase
import Core
import YallaKit

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
