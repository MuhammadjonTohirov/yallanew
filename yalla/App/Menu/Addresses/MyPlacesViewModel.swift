//
//  MyPlacesViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 04/11/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Combine
import Core

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
    @Published var showSnackbar: Bool = false
    @Published var snackbarMessage: String = ""
    @Published var clickedPlace: MyPlaceItem?
    
    private(set) var navigator: Navigator?
    private let interactor: MyPlacesInteractorProtocol
    
    init(interactor: MyPlacesInteractorProtocol = MyPlacesInteractor()) {
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
        do {
            let fetchedPlaces = try await interactor.fetchPlaces()
            self.places = fetchedPlaces
        } catch {
            print("Failed to fetch places: \(error)")
        }
    }
    
    func onClickAddNewPlace(type: MyAddressType) {
        navigator?.push(MyPlacesRouter.addPlace(type: type))
    }
    
    func onClickEditPlace() {
        guard let place = clickedPlace else { return }
        navigator?.push(MyPlacesRouter.updatePlace(item: place))
    }
    
    func onClickDeletePlace() {
        guard let place = clickedPlace else { return }
        deletePlace(place)
    }
    
    func onClickPlace(_ place: MyPlaceItem) {
        clickedPlace = place
    }
    
    private func deletePlace(_ place: MyPlaceItem) {
        Task {
            do {
                _ = try await interactor.deletePlace(place)
                await fetchPlaces()
                showSuccessSnackbar(message: "address.deleted.successfully".localize)
            } catch {
                print("Failed to delete place: \(error)")
            }
        }
    }
    
    private func showSuccessSnackbar(message: String) {
        snackbarMessage = message
        showSnackbar = true
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
