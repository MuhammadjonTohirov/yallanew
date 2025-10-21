//
//  InitialLoadingView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 14/10/25.
//

import Foundation
import SwiftUI
import Core

struct InitialLoadingView: View {
    @State
    private var fromColor: Color = .iPrimary
    
    @StateObject
    private var viewModel: InitialLoadingViewModel = .init()
    
    @State
    private var scale: CGFloat = 1
    
    var body: some View {
        ZStack {
            Color.iPrimaryDark
            .ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: fromColor.opacity(1), location: 0),
                .init(color: .iPrimaryDark.opacity(1), location: 1),
            ], center: .topLeading, startRadius: 0, endRadius: 500)

            
            Image("splash_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 193, height: 121)
                .scaleEffect(scale)
        }
        .ignoresSafeArea()

        .overlay {
            VStack(spacing: 27) {
                Spacer()
                ProgressView()
                    .colorScheme(.dark)
                Text("initial.loading.moto".localize)
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.white)
            .padding()
        }
        .onAppear {
            withAnimation {
                fromColor = .iPrimaryLite
                scale = 0.9
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                Task {
                    await viewModel.onAppear()
                }
            }
        }
    }
}

#Preview {
    InitialLoadingView()
}
