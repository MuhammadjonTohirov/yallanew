//
//  CreateUpdatePlaceViewModel.swift
//  Ildam
//
//  Created by applebro on 26/12/23.
//

import Foundation
import CoreLocation
import Core
import SwiftMessages
import Combine
import IldamSDK

class CreateUpdatePlaceViewModel: BaseViewModel {
    @Published var address: String = ""
    @Published var name: String = ""
    @Published var home: String = ""
    @Published var entrance: String = ""
    @Published var comment: String = ""
    @Published var showPickAddress: Bool = false
    
    @Published var shouldShowAlert: Bool = false
    @Published var isValidForm: Bool = false
    
    var addressItem: MyPlaceItem?
    var shouldCreate: Bool = true
    var addressPickerModel: SelectAddressViewModel = .init()
    
    @Published var isLoading: Bool = false
    
    private var cancellables: [AnyCancellable] = []
    private(set) var addressType: MyAddressType?
    private(set) var pickedLocation: CLLocation?
    
    init(addressItem: MyPlaceItem? = nil, addressType: MyAddressType = .other) {
        self.addressItem = addressItem
        self.addressType = addressType
        self.shouldCreate = addressItem == nil
    }
    
    override func onAppear() {
        super.onAppear()
        addressPickerModel.set(delegate: self)
        trackFormChanges()
        addressPickerModel.isToVisible = true
        set(addressItem: addressItem)
    }
    
    func set(addressItem: MyPlaceItem?) {
        self.address = addressItem?.address ?? ""
        self.name = addressItem?.name ?? ""
        self.home = addressItem?.apartment ?? ""
        self.entrance = addressItem?.enter ?? ""
        self.comment = addressItem?.comment ?? ""
        
        if let addressItem {
            self.pickedLocation = .init(latitude: addressItem.lat, longitude: addressItem.lng)
        }
    }
    
    func onSubmit(completion: @escaping (Bool) -> Void) {
        if isLoading {
            return
        }
        
        shouldCreate ? create(completion) : edit(completion)
    }
    
    func showAddressPicker() {
        self.addressPickerModel.isToVisible = true
        self.showPickAddress = true
    }
    
    private func trackFormChanges() {
        self.$address.debounce(for: 0.5, scheduler: RunLoop.main).sink { [weak self] _ in
            self?.checkIsValidForm()
        }.store(in: &cancellables)
        
        self.$name.debounce(for: 0.5, scheduler: RunLoop.main).sink { [weak self] _ in
            self?.checkIsValidForm()
        }.store(in: &cancellables)
    }
    
    private func edit(_ completion: @escaping (Bool) -> Void) {
        guard let addressItem, let pickedLocation, let addressType else {
            return
        }

        self.startLoading()

        Task {
            let req: UpdatePlaceRequest = .init(
                id: addressItem.id,
                name: self.name,
                address: self.address,
                lat: pickedLocation.coordinate.latitude,
                lng: pickedLocation.coordinate.longitude,
                type: addressType,
                enter: entrance,
                apartment: home,
                floor: self.addressItem?.floor,
                comment: comment
            )
            
            let isOK = await MainNetworkService.shared.updateMyPlace(req: req)
            
            self.showAlert(
                isOK ? "edit_success".localize : "edit_fail".localize,
                theme: isOK ? Theme.success : Theme.error
            )
                        
            completion(isOK)
            
            self.endLoading()
        }
    }
    
    private func create(_ completion: @escaping (Bool) -> Void) {
        guard let pickedLocation, let addressType else {
            return
        }
        
        self.startLoading()
        
        Task {
            
            let req: AddPlaceRequest = .init(
                name: self.name,
                address: self.address,
                lat: pickedLocation.coordinate.latitude,
                lng: pickedLocation.coordinate.longitude,
                type: addressType,
                enter: entrance,
                apartment: home,
                floor: self.addressItem?.floor, comment: comment)
            
            let isOK = await MainNetworkService.shared.addMyPlace(req: req)
            
            self.showAlert(
                isOK ? "create_success".localize : "create_fail".localize,
                theme: isOK ? Theme.success : Theme.error
            )
            
            completion(isOK)
            
            self.endLoading()
        }
    }
    
    private func startLoading() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    private func endLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    private func checkIsValidForm() {
        self.isValidForm = !name.isEmpty && !address.isEmpty && pickedLocation != nil
    }
    
    func showMapAddressPicker() {
        self.showPickAddress = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.addressPickerModel.isToVisible = true
        }
    }
    
    func showAlert(_ message: String, theme: Theme) {
        Snackbar.show(message: message, theme: theme)
    }
}

extension CreateUpdatePlaceViewModel: SelectAddressDelegate {
    func onSelect(model: SelectAddressViewModel, toAddress address: String, toCoordinate coordinate: CLLocation) {
        self.address = address
        self.pickedLocation = coordinate
        self.showPickAddress = false
    }
    
    func onSelect(model: SelectAddressViewModel, fromAddress address: String, fromCoordinate coordinate: CLLocation) {
        self.address = address
        self.pickedLocation = coordinate
        self.showPickAddress = false
    }
}
