//
//  HomeViewModel+BottomSheet.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import IldamSDK
import Core

extension HomeViewModel: SelectAddressDelegate {
    @MainActor
    func onClickToButton() async {
        guard let currentLocation = self.map?.pickedLocation,
              let currentAddress = currentLocation.name.nilIfEmpty
        else {
            return
        }
        
        var toAddress: SelectAddressItem?
        
        if let second = await TaxiOrderConfigProvider.shared.config.allPoints.last {
            toAddress = .init(id: second.id,address: second.address, coordinate: second.location)
        }

        self.selectAddressViewModel = .init(
            fromLocation: .init(
                address: currentAddress,
                coordinate: currentLocation.location
            ),
            toLocation: toAddress,
            focusedField: .to
        )
        
        self.selectAddressViewModel?.isToVisible = true
        self.selectAddressViewModel?.isFromVisible = true

        self.selectAddressViewModel?.set(delegate: self)
        
        self.showAddressPicker = true
    }
}
