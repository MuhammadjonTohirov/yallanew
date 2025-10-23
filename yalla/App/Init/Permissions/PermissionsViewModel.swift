//
//  PermissionsViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import Combine
import Core

@MainActor
final class PermissionsViewModel: ObservableObject {
    @MainActor
    @Published private(set) var currentPermission: PermissionType = .location
    @MainActor
    @Published private(set) var isRequesting: Bool = false
    @MainActor
    @Published private(set) var hasError: Bool = false
    @MainActor
    @Published private(set) var errorMessage: String = ""
    
    private let interactor: PermissionsInteractorProtocol
    private var didAppear: Bool = false
    
    init(interactor: PermissionsInteractorProtocol = PermissionsInteractor()) {
        self.interactor = interactor
    }
    
    var permissionTitle: String {
        switch currentPermission {
        case .location:
            return "permissions.location.title".localize
        case .notification:
            return "permissions.notification.title".localize
        }
    }
    
    var permissionDescription: String {
        switch currentPermission {
        case .location:
            return "permissions.location.description".localize
        case .notification:
            return "permissions.notification.description".localize
        }
    }
    
    var permissionImageName: String {
        switch currentPermission {
        case .location:
            return "img_pin"
        case .notification:
            return "img_bell"
        }
    }
    
    var buttonTitle: String {
        return "permissions.allow".localize
    }
    
    func onAppear() {
        guard !didAppear else { return }
        didAppear = true
        interactor.setupHandlers()
        checkInitialPermissions()
    }
    
    func allowPermission() {
        guard !isRequesting else { return }
        
        isRequesting = true
        hasError = false
        
        Task {
            let status: PermissionStatus
            
            switch currentPermission {
            case .location:
                status = await interactor.requestLocationPermission()
                await handleLocationPermissionResult(status)
            case .notification:
                status = await interactor.requestNotificationPermission()
                await handleNotificationPermissionResult(status)
            }
            
            isRequesting = false
        }
    }
    
    func skipPermission() {
        switch currentPermission {
        case .location:
            currentPermission = .notification
        case .notification:
            OnboardingFlags.didShowPermissions = true
            mainModel?.navigate(to: .auth)
        }
    }
    
    private func checkInitialPermissions() {
        Task { @MainActor in
            let locationStatus = interactor.checkLocationStatus()
            
            if locationStatus == .authorized {
                currentPermission = .notification
            }
        }
    }
    
    private func handleLocationPermissionResult(_ status: PermissionStatus) async {
        switch status {
        case .authorized, .denied:
            currentPermission = .notification
        case .notDetermined:
            hasError = true
            errorMessage = "permissions.error.general".localize
        }
    }
    
    private func handleNotificationPermissionResult(_ status: PermissionStatus) async {
        switch status {
        case .authorized, .denied:
            await MainActor.run {
                OnboardingFlags.didShowPermissions = true
                mainModel?.navigate(to: .auth)
            }
        case .notDetermined:
            hasError = true
            errorMessage = "permissions.error.general".localize
        }
    }
}
