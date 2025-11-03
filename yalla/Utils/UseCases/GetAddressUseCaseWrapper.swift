//
//  AddressFetcherAtLocation.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 16/05/25.
//

import Foundation
import IldamSDK
import CoreLocation

final class GetAddressUseCaseWrapper {
    private(set) var fetchAddressUseCase = GetAddressUseCase()
    private(set) var fetchAddressTask: Task<AddressResponse?, Never>?
    
    func fetchAddress(at location: CLLocationCoordinate2D) async throws -> AddressResponse? {
        fetchAddressTask?.cancel()
        
        fetchAddressTask = Task {
            await fetchAddressUseCase.execute(lat: location.latitude, lng: location.longitude)
        }
        
        var result = await fetchAddressTask?.value
        result?.lat = location.latitude
        result?.lng = location.longitude
        return result
    }
}

extension GetAddressUseCase: @unchecked @retroactive Sendable {
    
}
