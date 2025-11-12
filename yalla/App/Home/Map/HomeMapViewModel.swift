//
//  HomeMapViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import MapPack
import Combine
import YallaUtils
import SwiftUI
internal import _LocationEssentials

final class HomeMapViewModel: ObservableObject {
    private(set) var permissionManager: LocationPermissionManager = .shared
    private(set) var map: UniversalMapViewModel = .init(mapProvider: .mapLibre, input: nil)
    
    @MainActor
    @Published var geoPermission: LocationAuthorizationStatus?
    
    @Published
    @MainActor
    private(set) var bottomEdge: CGFloat = 0
    
    weak private(set)
    var delegate: HomeMapViewModelDelegate?
    
    private var didAppear: Bool = false
    
    init() {
        
    }
    
    func onAppear() {
        if didAppear { return }; didAppear = true
        
        // DO something on appear
        setup()
        focusToCurrentLocation() // needs to be removed later
    }
    
    func setup() {
        map.set(hasAddressPicker: true)
        map.set(hasAddressView: true)
        map.setInteractionDelegate(self)
        map.showUserLocation(true)
        
        locationPermissionSetup()
    }
}

extension HomeMapViewModel {
    // MARK: Set Actions
    @MainActor
    func setBottomEdge(_ height: CGFloat) {
        self.bottomEdge = height
        self.map.setEdgeInsets(.init(top: 0, left: 0, bottom: height, right: 0, animated: true, onEnd: nil))
    }
    
    func setDelegate(_ delegate: HomeMapViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: Actions
    
    // focus to current location
    func focusToCurrentLocation() {
        if geoPermission == .authorized {
            map.focusToCurrentLocation()
        } else {
            map.focusMap(on: .init(latitude: 40.380092, longitude: 71.789336))
        }
    }
}

extension HomeMapViewModel {
    func locationPermissionSetup() {
        onLocationPermissionChanged(with: self.permissionManager.currentStatus)
    }
    
    func locationChangeSubscription() {
        NotificationCenter.default.addObserver(
            forName: .locationPermissionChanged,
            object: nil,
            queue: .main
        ) { [weak self] val in
            guard let status = val.object as? LocationAuthorizationStatus else { return }
            
            Task { @MainActor in
                self?.onLocationPermissionChanged(with: status)
            }
        }
    }
    
    private func onLocationPermissionChanged(with status: LocationAuthorizationStatus) {
        Task { @MainActor in
            self.geoPermission = .denied
        }
    }
}
