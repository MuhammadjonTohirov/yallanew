//
//  PermissionsInteractor.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import YallaUtils

enum PermissionType {
    case location
    case notification
}

enum PermissionStatus {
    case notDetermined
    case authorized
    case denied
    
    init(from locationStatus: LocationAuthorizationStatus) {
        switch locationStatus {
        case .notDetermined:
            self = .notDetermined
        case .authorized:
            self = .authorized
        case .denied, .restricted:
            self = .denied
        }
    }
    
    init(from notificationStatus: NotificationAuthorizationStatus) {
        switch notificationStatus {
        case .notDetermined:
            self = .notDetermined
        case .authorized:
            self = .authorized
        case .denied:
            self = .denied
        }
    }
}

protocol PermissionsInteractorProtocol {
    func requestLocationPermission() async -> PermissionStatus
    func requestNotificationPermission() async -> PermissionStatus
    func checkLocationStatus() -> PermissionStatus
    func checkNotificationStatus() async -> PermissionStatus
    func setupHandlers()
}

@MainActor
final class PermissionsInteractor: PermissionsInteractorProtocol {
    private let locationManager = LocationPermissionManager.shared
    private let notificationManager = NotificationPermissionManager.shared
    
    private var locationContinuation: CheckedContinuation<PermissionStatus, Never>?
    
    func setupHandlers() {
        locationManager.statusChangeHandler = { [weak self] status in
            guard let self = self else { return }
            let permissionStatus = PermissionStatus(from: status)
            self.locationContinuation?.resume(returning: permissionStatus)
            self.locationContinuation = nil
        }
    }
    
    func requestLocationPermission() async -> PermissionStatus {
        let currentStatus = checkLocationStatus()
        
        if currentStatus != .notDetermined {
            return currentStatus
        }
        
        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestPermission()
        }
    }
    
    func requestNotificationPermission() async -> PermissionStatus {
        let status = await notificationManager.requestPermission()
        return PermissionStatus(from: status)
    }
    
    func checkLocationStatus() -> PermissionStatus {
        return PermissionStatus(from: locationManager.currentStatus)
    }
    
    func checkNotificationStatus() async -> PermissionStatus {
        let status = await notificationManager.checkStatus()
        return PermissionStatus(from: status)
    }
}
