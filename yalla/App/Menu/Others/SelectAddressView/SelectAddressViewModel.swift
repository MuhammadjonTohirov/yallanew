//
//  SelectAddressViewModel.swift
//  Ildam
//
//  Created by applebro on 22/12/23.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine
import Core
import IldamSDK
import MapPack

class SelectAddressViewModel: ObservableObject {
    @Published var fromAddressText: String = ""
    @Published var toAddressText: String = ""
    
    @Published var showMap: Bool = false
    @Published var addressList: [SelectAddressItem] = []
        
    @Published var selectedField: SelectAddressField = .to
    @Published var searchFailed: Bool = false
    
    var isFromVisible: Bool = false
    var isToVisible: Bool = true
    
    private(set) var shouldDismiss: Bool = false
    
    private(set) var input: SelectAddressViewModelInput?
    
    var fromAddress: SelectAddressItem?
    var toAddress: SelectAddressItem?
    
    @Published var isLoading: Bool = false
    
    private(set) weak var delegate: SelectAddressDelegate?
    private(set) var mapModel = PickAddressViewModel()
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(
        fromLocation: SelectAddressItem? = nil,
        toLocation: SelectAddressItem? = nil,
        focusedField: SelectAddressField = .to
    ) {
        self.input = .init(
            fromLocation: fromLocation,
            toLocation: toLocation,
            focusedField: focusedField
        )
        
        self.selectedField = focusedField
        
        self.isFromVisible = fromLocation != nil
        self.isToVisible = toLocation != nil
    }
    
    private var didAppear: Bool = false
    
    func onAppear() {
        shouldDismiss = false
        mapModel.set(delegate: self)
        
        if didAppear {
           return
        }
        
        didAppear = true
        setupAddressText()
    }
    
    private func setupAddressText() {
        Task {
            await MainActor.run {
                self.fromAddress = self.input?.fromLocation
                self.toAddress = self.input?.toLocation
                
                self.fromAddressText = self.fromAddress?.address ?? ""
                self.toAddressText = self.toAddress?.address ?? ""
            }
            
            await self.setupWithSecondaryAddress()
        }
    }
    
    func clearToAddress() {
        self.toAddressText = ""
        self.toAddress = nil
    }
    
    func clearFromAddress() {
        self.fromAddressText = ""
        
        guard let currentLocation = GLocationManager.shared.currentLocation else {
            self.fromAddress = nil
            return
        }
        
        self.fromAddress = SelectAddressItem(
            address: self.input?.fromLocation?.address ?? "",
            coordinate: currentLocation
        )
    }
    
    func showToAddressMapView() {
        self.selectedField = .to
        withAnimation {
            self.showMap(self.input?.toLocation?.coordinate ?? self.toAddress?.coordinate)
        }
    }
    
    func showFromAddressMapView() {
        self.selectedField = .from
        withAnimation {
            self.showMap(self.input?.fromLocation?.coordinate ?? self.fromAddress?.coordinate)
        }
    }
    
    func onSelect(address: SelectAddressItem) {
        switch selectedField {
        case .to:
            self.toAddress = address
        case .from:
            self.fromAddress = address
        }
    }
    
    func set(delegate: SelectAddressDelegate?) {
        self.delegate = delegate
    }
    
    func startSearching(_ field: SelectAddressField) {
        self.searchFailed = false
        let text = field == .from ? self.fromAddressText : self.toAddressText
        debugPrint("Start searching \(field) \(text)")
        Task {
            await self.showLoader()
            if text.isEmpty {
                await setupWithSecondaryAddress()
            } else {
                await setupWithSearchAddress(query: text)
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            await self.hideLoader()
            
            await MainActor.run {
                self.searchFailed = self.addressList.isEmpty
            }
        }
    }
    
    private func setupWithSearchAddress(query: String) async {
        let _addresses = await MainNetworkService.shared.loadAddress(text: query)
        
        Task { @MainActor in
            set(addressList: _addresses?.compactMap {
                SelectAddressItem(
                    id: $0.addressId ?? -1,
                    name: $0.addressName,
                    address: $0.name ?? "",
                    coordinate: .init(latitude: $0.lat, longitude: $0.lng),
                    distance: $0.distance
                )
            })
        }
    }
    
    private func setupWithSecondaryAddress() async {
        var location: CLLocation!
        
        location = (selectedField == .from ? self.fromAddress?.coordinate : self.toAddress?.coordinate)
        
        if location == nil, let pickedLocation = await TaxiOrderConfigProvider.shared.config.from?.location {
            location = pickedLocation
        }
        
        guard let location else {
            return
        }
        
        guard let _addresses = try? await FetchSecondaryAddressUseCaseImpl().fetch(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        ) else {
            return
        }
        
        Task { @MainActor in
            set(addressList: _addresses.map {
                SelectAddressItem(
                    id: $0.uniqueId,
                    name: $0.addressName,
                    address: $0.name ?? "",
                    coordinate: .init(latitude: $0.lat, longitude: $0.lng),
                    distance: $0.distance
                )
            })
        }
    }
    
    private func set(addressList: [SelectAddressItem]?) {
        self.addressList = addressList ?? []
    }
    
    func onSelectFromField() {
        selectedField = .from
        removeCancellables()
        
        $fromAddressText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main, options: nil)
            .removeDuplicates()
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.startSearching(.from)
            })
            .store(in: &cancellabels)
    }
    
    func onSelectToField() {
        selectedField = .to
        removeCancellables()
        
        $toAddressText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main, options: nil)
            .removeDuplicates()
            .dropFirst()
            .sink(receiveCompletion: { publisher in
                switch publisher {
                case .finished:
                    Logging.l("Finished editing to")
                case .failure(let failure):
                    Logging.l("Finished editing to with failure \(failure)")
                }
            }, receiveValue: { [weak self] _ in
                self?.startSearching(.to)
            })
            .store(in: &cancellabels)
    }
    
    func showMap(_ location: CLLocation?) {
        self.mapModel.focusLocation = location?.coordinate
        self.showMap = true
    }
    
    func closeMap() {
        self.showMap = false
    }
    
    private func removeCancellables() {
        cancellabels.forEach { $0.cancel() }
        cancellabels.removeAll()
    }
    
    @MainActor
    func showLoader() async {
        isLoading = true
    }
    
    @MainActor
    func hideLoader() async {
        isLoading = false
    }
    
    func onDisappear() {
        if input?.toLocation == nil, let new = toAddress {
            self.delegate?.onSelect(model: self, toAddress: new.address, toCoordinate: new.coordinate)
        } else if let from = self.input?.toLocation {
            self.delegate?.onEdit(
                model: self,
                toAddress: from,
                new: self.toAddress
            )
        }
        
        if let old = self.input?.fromLocation, let new = self.fromAddress  {
            self.delegate?.onEdit(
                model: self,
                fromAddress: old,
                new: new
            )
        }
        
        self.delegate?.selectAddress(
            model: self,
            finishWith: .init(
                fromLocation: self.fromAddress,
                toLocation: self.toAddress
            )
        )
        
        self.cancellabels.forEach { c in
            c.cancel()
        }
        
        self.cancellabels.removeAll()
    }
    
}

extension SelectAddressViewModel: PickAddressMapDelegate {
    
    func pickAddressOnClose(model: PickAddressViewModel) {
        self.closeMap()
    }
    
    func pickAddress(model: PickAddressViewModel, address: String, coordinate: AddressResponse) {
        let _address: SelectAddressItem = .init(id: coordinate.id, name: coordinate.name, address: coordinate.name, coordinate: coordinate.location, distance: coordinate.distance)
        
        switch selectedField {
        case .to:
            self.toAddress = _address
            self.toAddressText = address
        case .from:
            self.fromAddress = _address
            self.fromAddressText = address
        }
        
        self.closeMap()
        
        self.shouldDismiss = true
    }
}

extension SelectAddressItem: Hashable {
    static func == (lhs: SelectAddressItem, rhs: SelectAddressItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension AddressResponse {
    var coord: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
    
    var location: CLLocation {
        .init(latitude: self.lat, longitude: self.lng)
    }
}

extension SecondaryAddressItem {
    var coord: CLLocationCoordinate2D {
        .init(latitude: self.lat, longitude: self.lng)
    }
    
    var location: CLLocation {
        .init(latitude: self.lat, longitude: self.lng)
    }
}
