import Foundation
import IldamSDK
import Core

protocol MyPlacesInteractorProtocol {
    func fetchPlaces() async throws -> [MyPlaceItem]
    func deletePlace(_ place: MyPlaceItem) async throws -> Bool
}

final class MyPlacesInteractor: MyPlacesInteractorProtocol {
    func fetchPlaces() async throws -> [MyPlaceItem] {
        return await LoadMyPlacesUseCase().execute()
    }
    
    func deletePlace(_ place: MyPlaceItem) async throws -> Bool {
        await MainNetworkService.shared.deleteAddress(id: place.id)
    }
}

final class MockMyPlacesInteractor: MyPlacesInteractorProtocol {
    func fetchPlaces() async throws -> [MyPlaceItem] {
        try await Task.sleep(for: .milliseconds(1000))

        return [
            .init(id: 0, name: "Mening uyim", address: "12, Fergana", lat: 9, lng: 9, type: .home, enter: nil, apartment: nil, floor: nil, comment: nil, createdAt: Date().timeIntervalSince1970.description)
        ]
    }
    
    func deletePlace(_ place: MyPlaceItem) async throws -> Bool {
        try await Task.sleep(for: .milliseconds(1000))
        return false
    }
}
