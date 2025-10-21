//
//  LocationPermissionManager.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import CoreLocation

public class LocationPermissionManager: NSObject, @unchecked Sendable {
    public static let shared = LocationPermissionManager()
    
    public var statusChangeHandler: ((LocationAuthorizationStatus) -> Void)?
    
    private let locationManager = CLLocationManager()
    
    public var currentStatus: LocationAuthorizationStatus {
        LocationAuthorizationStatus(from: locationManager.authorizationStatus)
    }
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestPermissionIfNeeded() {
        guard currentStatus == .notDetermined else { return }
        requestPermission()
    }
}

extension LocationPermissionManager: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = LocationAuthorizationStatus(from: manager.authorizationStatus)
        statusChangeHandler?(status)
        
        NotificationCenter.default.post(
            name: .locationPermissionChanged,
            object: status
        )
    }
}

public enum LocationAuthorizationStatus: Equatable, Sendable {
    case notDetermined
    case authorized
    case denied
    case restricted
    
    init(from clStatus: CLAuthorizationStatus) {
        switch clStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self = .authorized
        case .denied:
            self = .denied
        case .restricted:
            self = .restricted
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
        self == .denied || self == .restricted
    }
}

public extension NSNotification.Name {
    static var locationPermissionChanged: NSNotification.Name {
        .init("locationPermissionChanged")
    }
}
