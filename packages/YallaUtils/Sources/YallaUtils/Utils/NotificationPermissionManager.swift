//
//  NotificationPermissionManager.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import UserNotifications
import UIKit
import Combine

public class NotificationPermissionManager: @unchecked Sendable {
    public static let shared = NotificationPermissionManager()
    
    public var statusChangeHandler: ((NotificationAuthorizationStatus) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    private var currentStatusCache: NotificationAuthorizationStatus = .notDetermined
    
    public var currentStatus: NotificationAuthorizationStatus {
        currentStatusCache
    }
    
    private init() {
        startMonitoring()
    }
    
    public func requestPermission() async -> NotificationAuthorizationStatus {
        let currentStatus = await checkStatus()
        
        guard currentStatus == .notDetermined else {
            return currentStatus
        }
        
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            
            let status: NotificationAuthorizationStatus = granted ? .authorized : .denied
            updateStatus(status)
            return status
        } catch {
            updateStatus(.denied)
            return .denied
        }
    }
    
    public func checkStatus() async -> NotificationAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        let status = NotificationAuthorizationStatus(from: settings.authorizationStatus)
        updateStatus(status)
        return status
    }
    
    private func updateStatus(_ status: NotificationAuthorizationStatus) {
        guard currentStatusCache != status else { return }
        
        currentStatusCache = status
        statusChangeHandler?(status)
        
        NotificationCenter.default.post(
            name: .notificationPermissionChanged,
            object: status
        )
    }
    
    private func startMonitoring() {
        Task {
            _ = await checkStatus()
        }
        
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                Task { [weak self] in
                    _ = await self?.checkStatus()
                }
            }
            .store(in: &cancellables)
    }
}

public enum NotificationAuthorizationStatus: Equatable, Sendable {
    case notDetermined
    case authorized
    case denied
    
    init(from unStatus: UNAuthorizationStatus) {
        switch unStatus {
        case .authorized, .provisional, .ephemeral:
            self = .authorized
        case .denied:
            self = .denied
        case .notDetermined:
            self = .notDetermined
        @unknown default:
            self = .notDetermined
        }
    }
    
    public var isAuthorized: Bool {
        self == .authorized
    }
    
    public var isDenied: Bool {
        self == .denied
    }
}

public extension NSNotification.Name {
    static var notificationPermissionChanged: NSNotification.Name {
        .init("notificationPermissionChanged")
    }
}
