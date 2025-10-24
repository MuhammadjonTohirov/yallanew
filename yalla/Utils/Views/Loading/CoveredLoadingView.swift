//
//  CoveredLoadingView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/11/23.
//

import Foundation
import SwiftUI
import Core

public struct CoveredLoadingView: View {
    @Binding public var isLoading: Bool
    public var message: String
    
    init(isLoading: Binding<Bool>, message: String) {
        self._isLoading = isLoading
        self.message = message
    }
    
    public var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(Color.background.opacity(0.6))
            .ignoresSafeArea()
            .overlay {
                VStack {
                    LoadingIndicator(animation: .circleTrim, color: .label, size: .medium, speed: .normal)
                    
                    Text(message)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.background)
                                .blur(radius: 10)
                        }
                }
            }.opacity(isLoading ? 1 : 0)
    }
}
