//
//  HomeMapViewModel+Map.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import MapPack
internal import _LocationEssentials

extension HomeMapViewModel: UniversalMapViewModelDelegate {
    
    func mapDidEndDragging(map: any MapProviderProtocol, at location: CLLocation) {
        delegate?.homeMap(self, dragging: false)
    }
    
    func mapDidStartMoving(map: any MapProviderProtocol) {
        
    }
    
    func mapDidStartDragging(map: any MapProviderProtocol) {
        delegate?.homeMap(self, dragging: true)
    }
}

