//
//  HomeMapViewModel+Map.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import MapPack
import Core
import IldamSDK
internal import _LocationEssentials

extension HomeMapViewModel: UniversalMapViewModelDelegate {
    
    func mapDidEndDragging(map: any MapProviderProtocol, at location: CLLocation) {
        Logging.l(tag: "HomeMapViewModel", "Did end dragging map")
        Task {
            do {
                let location = try await interactor.fetchAddress(at: location)
                await MainActor.run {
                    self.pickedLocation = location
                    if let location {
                        self.map.set(addressViewInfo: .init(name: location.name, location: location.coord))
                    }
                }
            } catch {
                
            }
            
            delegate?.homeMap(self, dragging: false)
        }
    }
    
    func mapDidStartMoving(map: any MapProviderProtocol) {
        
    }
    
    func mapDidStartDragging(map: any MapProviderProtocol) {
        Logging.l(tag: "HomeMapViewModel", "Did start dragging map")
        delegate?.homeMap(self, dragging: true)
    }
}

