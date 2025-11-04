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
            .foregroundStyle(Color.init(hex: "#10182833").opacity(0.2))
            .ignoresSafeArea()
            .overlay {
                VStack {
                    Circle()
                        .frame(width: 70.scaled, height: 70.scaled)
                        .foregroundStyle(.iBackground)
                        .overlay {
                            ProgressView()
                                .tint(.iPrimary)
                                .scaleEffect(1.5)
                        }
                    
                    Text(message)
                        .padding(8)
                        .font(.bodyBaseMedium)
                        .foregroundStyle(.iLabel)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.iBackground)
                                .blur(radius: 10)
                        }
                }
            }.opacity(isLoading ? 1 : 0)
    }
}

#Preview {
    CoveredLoadingView(isLoading: .constant(true), message: "Please wait")
}
