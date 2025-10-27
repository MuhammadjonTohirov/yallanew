//
//  AppSheetModifier.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 27/10/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core

struct AppSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var title: String
    var sheetContent: () -> SheetContent
    
    @State private var rect: CGRect?
    private var radius: CGFloat = AppParams.Radius.large
    init(isPresented: Binding<Bool>, title: String = "", radius: CGFloat = AppParams.Radius.large, sheetContent: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self.title = title
        self.sheetContent = sheetContent
        self.radius = radius
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                ScrollView(.vertical) {
                    VStack {
                        HStack {
                            DismissCircleButton()
                            Spacer()
                        }
                        .overlay(content: {
                            Text(title)
                                .font(.bodyLargeMedium)
                        })
                        .padding(16.scaled)
                        
                        sheetContent()
                    }
                    .readRect { rect in
                        self.rect = rect
                    }
                    .scrollIndicators(.hidden)
                }
                .presentationDetents([.height(((rect?.height) ?? 0) + UIApplication.shared.safeArea.bottom)])
                .presentationCornerRadius(radius)
                .presentationDragIndicator(.visible)
            }
    }
}


extension View {
    func appSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        title: String = "",
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) -> some View {
        modifier(AppSheetModifier(isPresented: isPresented, title: title, sheetContent: sheetContent))
    }
}
