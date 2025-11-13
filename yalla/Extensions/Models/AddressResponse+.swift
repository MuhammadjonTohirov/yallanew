//
//  AddressResponse+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 13/11/25.
//

import Foundation
import YallaKit

extension AddressResponse {
    var gpoint: GRoutePoint? {
        guard let _id = self.id else {
            return nil
        }
        return .init(id: _id, order: -1, location: self.location, address: self.name)
    }
}

