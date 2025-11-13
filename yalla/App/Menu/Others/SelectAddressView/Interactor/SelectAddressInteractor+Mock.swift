//
//  SelectAddressInteractor+Mock.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import CoreLocation
import IldamSDK

struct SelectAddressMockInteractor: SelectAddressInteractorProtocol {
    func fetchSecondaryAddresses(lat: Double, lng: Double) async throws -> [SelectAddressItem] {
        return [
            .init(id: 0, name: "Pharmacy", address: "Istirohat ko'chasi, 29/31", coordinate: .init(latitude: 40.393527, longitude: 71.773780), distance: 1200)
        ]
    }
    
    func searchAddresses(query: String) async throws -> [SelectAddressItem] {
        return [
            .init(id: 0, name: "Pharmacy", address: "Istirohat ko'chasi, 29/31", coordinate: .init(latitude: 40.393527, longitude: 71.773780), distance: 1200)
        ]
    }
}
