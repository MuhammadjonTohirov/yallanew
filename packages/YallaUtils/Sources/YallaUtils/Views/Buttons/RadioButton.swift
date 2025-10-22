//
//  RadioButton.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import SwiftUI

public struct RadioButton<Content: View>: View {
    let title: Content
    var isSelected: Bool
    var selectedColor: Color
    let action: () -> Void
    
    public init(title: Content, isSelected: Bool, selectedColor: Color = Color.init(uiColor: .label), action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.selectedColor = selectedColor
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Circle()
                    .foregroundStyle(selectedColor.opacity(0.2))
                    .frame(width: 20, height: 20)
                    .overlay {
                        Circle().stroke(lineWidth: isSelected ? 4 : 0)
                            .frame(width: 18, height: 18)
                    }
                
                AnyView(title)
            }
            .foregroundColor(isSelected ? selectedColor : selectedColor.opacity(0.2))
        }
        .buttonStyle(.plain)
    }
}

