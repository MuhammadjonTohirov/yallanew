//
//  SelectAddressItem+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 13/11/25.
//

import Foundation
import YallaKit

extension SelectAddressItem {
    var routePoint: GRoutePoint {
        .init(id: self.id, order: -1, location: self.coordinate, address: self.address)
    }
}
