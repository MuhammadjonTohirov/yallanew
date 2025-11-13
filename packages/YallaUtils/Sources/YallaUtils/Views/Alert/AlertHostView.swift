//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation
import SwiftUI

// View that hosts the alert UI
struct AlertHostView: View {
    @ObservedObject var alertManager: YallaAlertManager

    var body: some View {
        ZStack {
            if alertManager.isPresented {
                // Semi-transparent background
                Color.black
                    .opacity(0.14)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        alertManager.dismiss()
                    }
                
                // Alert content
                VStack {
                    if let customContent = alertManager.customContent {
                        PopupView(
                            title: alertManager.title,
                            message: alertManager.message,
                            buttons: alertManager.buttons,
                            content: { customContent }
                        )
                        .background(Color.init(uiColor: .tertiarySystemBackground))
                        .cornerRadius(38)
                        .padding(.horizontal, 20)
                    } else {
                        PopupView<EmptyView>(
                            title: alertManager.title,
                            message: alertManager.message,
                            buttons: alertManager.buttons
                        )
                        .background(Color.init(uiColor: .tertiarySystemBackground))
                        .cornerRadius(38)
                        .padding(.horizontal, 20)
                    }
                }
                .transition(.scale.combined(with: .opacity))
                .scaleEffect(alertManager.scale)
                .opacity(alertManager.scale)
                .animation(.spring(duration: 0.2), value: alertManager.scale)
                .onAppear {
                    alertManager.scale = 1
                }
            }
        }
        
//        .animation(.easeInOut(duration: 0.2), value: alertManager.isPresented)
    }
}

