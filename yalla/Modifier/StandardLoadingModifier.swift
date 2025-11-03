//
//  StandardLoadingModifier.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 31/10/25.
//

import Foundation
import SwiftUI
import Core

struct StandardLoadingModifier: ViewModifier {
    var isLoading: Bool
    
    func body(content: Content) -> some View {
        content.overlay {
            ZStack {
                Color.black.opacity(0.2)
                LoadingIndicator(animation: .circleTrim, color: .white, size: .medium, speed: .normal)
            }
            .ignoresSafeArea()
            .id(isLoading)
            .visibility(isLoading)
        }
    }
}
