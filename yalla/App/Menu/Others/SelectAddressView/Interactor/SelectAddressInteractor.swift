//
//  SelectAddressInteractor.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import CoreLocation
import IldamSDK

protocol SelectAddressInteractorProtocol {
    func fetchSecondaryAddresses(lat: Double, lng: Double) async throws -> [SelectAddressItem]
    func searchAddresses(query: String) async throws -> [SelectAddressItem]
}

struct SelectAddressInteractor: SelectAddressInteractorProtocol {
    func fetchSecondaryAddresses(lat: Double, lng: Double) async throws -> [SelectAddressItem] {
        guard let _addresses = try? await FetchSecondaryAddressUseCaseImpl().fetch(
            lat: lat,
            lng: lng
        ) else {
            return []
        }
        
        return _addresses.map {
            SelectAddressItem(
                id: $0.uniqueId,
                name: $0.addressName,
                address: $0.name ?? "",
                coordinate: .init(latitude: $0.lat, longitude: $0.lng),
                distance: $0.distance
            )
        }
    }
    
    func searchAddresses(query: String) async throws -> [SelectAddressItem] {
        let _addresses = await MainNetworkService.shared.loadAddress(text: query)
        
        return _addresses?.compactMap {
            SelectAddressItem(
                id: $0.addressId ?? -1,
                name: $0.addressName,
                address: $0.name ?? "",
                coordinate: .init(latitude: $0.lat, longitude: $0.lng),
                distance: $0.distance
            )
        } ?? []
    }
}
