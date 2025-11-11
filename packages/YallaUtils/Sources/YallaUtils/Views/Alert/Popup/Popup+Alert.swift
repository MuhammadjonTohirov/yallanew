//
//  FAlert.swift
//  Core
//
//  Created by Muhammadjon Tohirov on 03/03/25.
//

import Foundation
import Foundation
import SwiftUI

public struct PupupAlert<PopupContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let popupContent: PopupContent
    
    public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> PopupContent) {
        self._isPresented = isPresented
        self.popupContent = content()
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
            
            if isPresented {
                Color.black
                    .opacity(0.12)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack {
                    self.popupContent
                        .background(Color.init(uiColor: .tertiarySystemBackground))
                        .cornerRadius(38)
                        .padding(.horizontal, 20)
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

// Example of how to use it
struct ContentView: View {
    @State private var showPopup = false
    @State private var showMultiButtonPopup = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("Show Standard Alert") {
                    showPopup = true
                }
                
                Button("Show Multi-Button Alert") {
                    showMultiButtonPopup = true
                }
            }
            .navigationTitle("Custom Popup Demo")
            .customPopup(isPresented: $showPopup) {
                PopupView<EmptyView>(
                    title: "Отменить заказ?",
                    message: "Ищем машину для вас, но если отмените сейчас, поиск новой займет больше времени.",
                    primaryButtonTitle: "Отменить заказ",
                    primaryAction: {
                        // Handle cancel action
                        showPopup = false
                    },
                    secondaryButtonTitle: "Продолжить поиск",
                    secondaryAction: {
                        // Handle continue action
                        showPopup = false
                    }
                )
            }
        }
    }
}

// SwiftUI preview for testing
#Preview {
    ContentView()
}
