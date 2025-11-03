//
//  PickAddressMapViewModel.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 25/02/25.
//

import Foundation
import MapPack
import CoreLocation
import Core
import SwiftUI
import IldamSDK
import Combine

final class GoogleMapInput: GoogleMapsKeyProvider {
    let accessKey: String = "AIzaSyC_dHd88uaz8yUlmxKbvXo7n-a7mPhgaWI"
}

protocol PickAddressMapDelegate: AnyObject {
    func pickAddressOnClose(model: PickAddressViewModel)
    func pickAddress(model: PickAddressViewModel, address: String, coordinate: AddressResponse)
}

extension PickAddressMapDelegate {
    func pickAddressOnClose(model: PickAddressViewModel) {}
    func pickAddress(model: PickAddressViewModel, address: String, coordinate: AddressResponse) {}
}

class PickAddressViewModel: BaseViewModel, @unchecked Sendable {
    private var appConfigUseCase: AppConfigUseCase = AppConfigUseCaseImpl()

    var mapProvider: MapProvider {
//        if appConfigUseCase.appConfig?.isGoogleMap ?? false {
//            return .google
//        }

        return .mapLibre
    }
    
    var mapInput: (any UniversalMapInputProvider)? {
        switch mapProvider {
        case .google:
            return GoogleMapInput()
        case .mapLibre:
            return nil
        }
    }
    
    private(set) lazy var mapModel: UniversalMapViewModel = UniversalMapViewModel(mapProvider: self.mapProvider, input: self.mapInput)
    
    @Published var address: String = ""
    
    var placeholder: String = "searching".localize
    
    var focusLocation: CLLocationCoordinate2D?
    
    private(set) weak var delegate: PickAddressMapDelegate?
    private(set) var pickedLocation: AddressResponse? {
        didSet {
            self.address = pickedLocation?.name ?? ""
        }
    }
    
    @Published private(set) var isLoading: Bool = true
    
    override func onAppear() {
        super.onAppear()
        mapModel.setInteractionDelegate(self)
        mapModel.set(hasAddressPicker: true)
        mapModel.set(hasAddressView: true)
        mapModel.showUserLocation(true)
        
        let safeArea = UIApplication.shared.safeArea
        mapModel.setEdgeInsets(.init(top: safeArea.top, left: 0, bottom: safeArea.top + 100, right: 0, animated: false, onEnd: nil))
    }
    
    func set(delegate: PickAddressMapDelegate?) {
        self.delegate = delegate
    }
    
    func onClickClose() {
        self.delegate?.pickAddressOnClose(model: self)
    }
    
    func onClickSelect() {
        guard let pickedLocation else {
            return
        }
        
        self.delegate?.pickAddress(model: self, address: self.address, coordinate: pickedLocation)
    }
    
    @MainActor
    private func hideLoading() {
        withAnimation {
            self.isLoading = false
        }
    }
    
    @MainActor
    private func showLoading() {
        withAnimation {
            self.isLoading = true
        }
    }
    
    @MainActor
    func focusToDesignatedLocation() {
        showLoading()
        
        guard let focusLocation else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusToCurrentLocation(animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.hideLoading()
                }
            }
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mapModel.focusMap(on: .init(latitude: focusLocation.latitude, longitude: focusLocation.longitude), zoom: 15, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.hideLoading()
            }
        }
    }
    
    @MainActor
    func focusToCurrentLocation(animated: Bool = true) {
        self.mapModel.focusToCurrentLocation(animated: animated)
    }
}

extension PickAddressViewModel: UniversalMapViewModelDelegate {
    func mapDidStartMoving(map: any MapProviderProtocol) {
        self.mapModel.pinModel.set(state: .pinning)
    }
    
    func mapDidStartDragging(map: any MapProviderProtocol) {
        self.mapModel.pinModel.set(state: .pinning)
    }
    
    func mapDidEndDragging(map: any MapProviderProtocol, at location: CLLocation) {
        self.mapModel.pinModel.set(state: .initial)
        
        Task {
            let result = try? await GetAddressUseCaseWrapper().fetchAddress(at: location.coordinate)
            Task {@MainActor in
                self.mapModel.addressInfo = .init(name: result?.name, location: result?.location.coordinate)
                self.pickedLocation = result
            }
        }
    }
}

