//
//  HomeMapViewModel+Action.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation
import YallaUtils

extension HomeMapViewModel {
    func onClickFocusButton() {
        if geoPermission == .authorized {
            focusToCurrentLocation()
        } else {
            alertLocationPermissionRequired()
        }
    }
}
