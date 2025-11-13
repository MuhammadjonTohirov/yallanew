//
//  HomeViewModel+Map.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import SwiftUI

extension HomeViewModel: HomeMapViewModelDelegate {
    nonisolated func homeMap(_ viewModel: HomeMapViewModel, dragging: Bool) {
        Task { @MainActor in
            if dragging {
                HomePropertiesHolder.shared.set(isBottomSheetMinimized: true)
//                valueHolder?.set(isBottomSheetMinimized: true)
            } else {
                HomePropertiesHolder.shared.set(isBottomSheetMinimized: false)
//                valueHolder?.set(isBottomSheetMinimized: false)
            }
        }
    }
}
