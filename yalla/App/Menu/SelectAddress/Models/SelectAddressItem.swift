//
//  SelectItemAddress.swift
//  Ildam
//
//  Created by applebro on 10/01/24.
//

import Foundation
import CoreLocation
import Core

struct SelectAddressItem: Identifiable {
    var id: Int
    
    var coordId: String {
        coordinate.identifier
    }
    
    var name: String?
    var address: String
    var coordinate: CLLocation
    var distance: Double?
    
    init(id: Int? = nil, name: String? = nil, address: String, coordinate: CLLocation, distance: Double? = nil) {
        self.id = id ?? coordinate.uniqeIntId
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.distance = distance
    }
}

extension SelectAddressItem {
    var distanceString: String {
        guard let distance = distance else {
            return ""
        }
        
        return String(format: "%.1f km", distance)
    }
}

extension CLLocation {
    var uniqeIntId: Int {
        return Int(generateLocationID(lat: self.coordinate.latitude, lon: self.coordinate.longitude))
    }
    
    private func generateLocationID(lat: Double, lon: Double) -> Int64 {
        let precision = 1e5  // adjust as needed for your application

        // Convert to integers
        let latInt = Int64((lat + 90.0) * precision)  // shift to make all positive
        let lonInt = Int64((lon + 180.0) * precision)

        // Combine them into one Int64: 32 bits for each part
        let locationID = (latInt << 32) | lonInt
        return locationID
    }
}
