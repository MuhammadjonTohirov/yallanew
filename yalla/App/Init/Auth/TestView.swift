//
//  TestView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import SwiftUI
import Core

struct HostView: View {
    @State private var showSheet = false

    var body: some View {
        Button("test".localize) { showSheet = true }
            .sheet(isPresented: $showSheet) {
                NavigationStack {
                    SheetRoot()
                        .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.large])                 // or [.medium, .large]
                .presentationDragIndicator(.visible)            // shows the grabber
                .interactiveDismissDisabled(false)              // allow drag-down
            }
    }
}

struct SheetRoot: View {
    var body: some View {
        VStack(spacing: 16) {
            Text(verbatim: "Sheet Root")
            NavigationLink("Go deeper".localize) { Text(verbatim: "Next screen") }
        }
        .padding()
    }
}

#Preview {
    HostView()
}
