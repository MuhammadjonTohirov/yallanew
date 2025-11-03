//
//  SelectAddressResult.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 24/07/25.
//

import Foundation
import Combine

struct SelectAddressViewModelInput {
    var fromLocation: SelectAddressItem?
    var toLocation: SelectAddressItem?
    var focusedField: SelectAddressField
}

struct SelectAddressResult {
    var fromLocation: SelectAddressItem?
    var toLocation: SelectAddressItem?
}
