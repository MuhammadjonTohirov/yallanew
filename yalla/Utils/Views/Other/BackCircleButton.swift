//
//  BackCircleButton.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 22/10/25.
//

import Foundation
import SwiftUI
import YallaUtils

struct BackCircleButton: View {
    @Environment(\.dismiss) var presentationMode
    
    var body: some View {
        Button(action: {
            self.presentationMode.callAsFunction()
        }) {
            Circle()
                .stroke(lineWidth: 1, color: Color.iBorderDisabled, visible: true)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "arrow.backward")
                        .foregroundStyle(Color.init(uiColor: .label))
                }
        }
    }
}
