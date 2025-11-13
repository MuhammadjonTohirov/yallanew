//
//  HomeViewModel+ValueHolder.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation

extension HomeViewModel {
    @MainActor
    func setValue(bottomSheetHeight: CGFloat) {
        HomePropertiesHolder.shared.setBottomSheetHeight(bottomSheetHeight)
    }
}
