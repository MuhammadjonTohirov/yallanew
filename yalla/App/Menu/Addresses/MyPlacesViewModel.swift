//
//  MyPlacesViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 04/11/25.
//

import Foundation
import SwiftUI
import SwiftMessages
import IldamSDK
import YallaUtils
import Combine
import Core

enum MyPlacesSheetState: String, Identifiable {
    var id: String {
        self.rawValue.identifier
    }
    
    case menu
    case delete
}

enum MyPlacesRouter: SceneDestination {
    case addPlace(type: MyAddressType)
    case updatePlace(item: MyPlaceItem)
    
    var scene: some View {
        switch self {
        case .addPlace(let type):
            CreateUpdatePlaceView(addressType: type)
        case .updatePlace(let item):
            CreateUpdatePlaceView(addressItem: item)
        }
    }
}

@MainActor
class MyPlacesViewModel: ObservableObject {
    @Published var places: [MyPlaceItem] = []
    @Published var sheet: MyPlacesSheetState?
    @Published var isLoading: Bool = false
    
    var clickedPlace: MyPlaceItem?
    
    private(set) var navigator: Navigator?
    private let interactor: MyPlacesInteractorProtocol
    
    init(interactor: MyPlacesInteractorProtocol = MockMyPlacesInteractor()) {
        self.interactor = interactor
    }
    
    var home: MyPlaceItem? {
        places.first { $0.type == MyAddressType.home }
    }
    
    var work: MyPlaceItem? {
        places.first { $0.type == MyAddressType.work }
    }
    
    var others: [MyPlaceItem] {
        places.filter { $0.type == MyAddressType.other || $0.type == nil }
    }
    
    func onAppear() {
        Task {
            await fetchPlaces()
        }
    }
    
    func setNavigator(_ navigator: Navigator?) {
        self.navigator = navigator
    }
    
    private func fetchPlaces() async {
        await setLoading(true)
        do {
            let fetchedPlaces = try await interactor.fetchPlaces()
            self.places = fetchedPlaces
        } catch {
            print("Failed to fetch places: \(error)")
        }
        
        await setLoading(false)
    }
    
    func onClickAddNewPlace(type: MyAddressType) {
        navigator?.push(MyPlacesRouter.addPlace(type: type))
    }
    
    func onClickEditPlace() {
        guard let place = clickedPlace else { return }
        self.navigator?.push(MyPlacesRouter.updatePlace(item: place))
        setSheet(nil)
    }
    
    func onClickDeletePlace() {
        if sheet == .delete, let clickedPlace {
            self.deletePlace(clickedPlace)
            self.setSheet(nil)
        } else {
            self.setSheet(.delete)
        }
    }
    
    func onClickPlace(_ place: MyPlaceItem) {
        clickedPlace = place
        setSheet(.menu)
    }
    
    private func deletePlace(_ place: MyPlaceItem) {
        Task {
            await setLoading(true)

            do {
                _ = try await interactor.deletePlace(place)
                await fetchPlaces()
                showSuccessSnackbar(message: "address.deleted.successfully".localize)
            } catch {
                print("Failed to delete place: \(error)")
            }
            
            await setLoading(false)
        }
    }
    
    private func showSuccessSnackbar(message: String) {
        Snackbar.show(message: message, theme: .success)
    }
    
    private func setSheet(_ sheet: MyPlacesSheetState?) {
        if self.sheet != nil {
            self.sheet = nil
        } else {
            self.sheet = sheet
        }
        
        guard sheet != nil else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.sheet = sheet
        }
    }
    
    @MainActor
    func setLoading(_ isLoading: Bool) async {
        self.isLoading = isLoading
    }
}

extension MyPlaceItem {
    var fullAddress: String {
        [
            self.name,
            self.address
        ].joined(separator: " • ")
    }
}
