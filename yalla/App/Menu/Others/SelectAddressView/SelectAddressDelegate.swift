//
//  SelectAddressDelegate.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 24/07/25.
//

import Foundation
import CoreLocation

protocol SelectAddressDelegate: AnyObject {
    func onSelect(model: SelectAddressViewModel, fromAddress: String, fromCoordinate: CLLocation)
    func onSelect(model: SelectAddressViewModel, toAddress: String, toCoordinate: CLLocation)
    
    func onEdit(model: SelectAddressViewModel, toAddress address: SelectAddressItem, new with: SelectAddressItem?)
    func onEdit(model: SelectAddressViewModel, fromAddress address: SelectAddressItem, new with: SelectAddressItem)
    
    func selectAddress(model: SelectAddressViewModel, finishWith result: SelectAddressResult)
}

extension SelectAddressDelegate {
    func onSelect(model: SelectAddressViewModel, fromAddress: String, fromCoordinate: CLLocation) {}
    func onSelect(model: SelectAddressViewModel, toAddress: String, toCoordinate: CLLocation) {}

    func onEdit(model: SelectAddressViewModel, toAddress address: SelectAddressItem, new with: SelectAddressItem?) {}
    func onEdit(model: SelectAddressViewModel, fromAddress address: SelectAddressItem, new with: SelectAddressItem) {}
    
    func selectAddress(model: SelectAddressViewModel, finishWith result: SelectAddressResult) {}
}
