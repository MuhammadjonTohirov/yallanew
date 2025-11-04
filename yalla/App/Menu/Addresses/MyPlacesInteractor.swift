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
        return []
    }
    
    func deletePlace(_ place: MyPlaceItem) async throws -> Bool {
        true
    }
}
