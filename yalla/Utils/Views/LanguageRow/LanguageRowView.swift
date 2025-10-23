//
//  LanguageRowView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core

struct LanguageRowView: View {
    let language: LanguageProtocol
    @Binding var selected: Bool
    
    var body: some View {
        SelectableButtonContainer.init(action: {
            
        }, content: {
            HStack {
                image(for: language)?
                    .resizable()
                    .frame(width: 32, height: 32)
                Text(self.language.name)
                    .font(.headline)
            }
        }, isSelected: $selected)
    }
    
    private func image(for language: LanguageProtocol) -> Image? {
        switch language {
        case is LanguageUz:
            return .init("icon_uzbekistan")
        case is LanguageRu:
            return .init("icon_russia")
        case is LanguageUzCryl:
            return .init("icon_uzbekistan")
        case is LanguageEn:
            return .init("icon_united kingdom")
        default:
            return nil
        }
    }
}

#Preview {
    LanguageRowView(language: LanguageEn(), selected: .constant(false))
}
