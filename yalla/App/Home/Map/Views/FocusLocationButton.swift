//
//  FocusLocationButton.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import SwiftUI
import Core

struct FocusLocationButton: View {
    enum ButtonState {
        case normal
        case disabled
    }
    
    var state: ButtonState = .normal
    
    var onClick: () -> Void = { }
    
    private var backgroundColor: Color {
        switch state {
        case .normal:
            return .background
        case .disabled:
            return .red
        }
    }
    
    private var contentColor: Color {
        switch state {
        case .normal:
            return .label
        case .disabled:
            return .white
        }
    }
    
    var body: some View {
        HStack {
            Text("enable.gps".localize)
                .lineLimit(2)
                .font(.bodyCaptionMedium)
                .padding(.leading, 20.scaled)
                .visibility(state == .disabled)
            Image("icon_gps")
                .renderingMode(.template)
                .padding(12.scaled)
        }
        .animation(.spring, value: state)
        .foregroundStyle(contentColor)
        .frame(height: 48.scaled)
        .frame(minWidth: 48.scaled)
        .onTapped(backgroundColor, action: onClick)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
    }
}

#Preview {
    FocusLocationButton()
}
