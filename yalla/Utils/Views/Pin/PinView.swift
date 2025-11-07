//
//  PinView.swift
//  IldamMap
//
//  Created by applebro on 09/09/24.
//

import Foundation
import SwiftUI
import Core

public struct PinView: View {
    @ObservedObject var vm: PinViewModel// = .init()
    @State private var isPinAnimating: Bool = false
    
    private var shift: CGFloat {
        if vm.state == .pinning {
            return isPinAnimating ? 12 : 6
        }
        
        return 0
    }
    
    private var offsetY: CGFloat {
        if vm.state == .searching {
            return 0
        }
        
        return -28 - shift
    }
    
    public init(vm: PinViewModel) {
        self.vm = vm
    }
    
    public var body: some View {
        innerBody
            .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    var innerBody: some View {
        ZStack {
            Ellipse()
                .frame(width: 18, height: 4)
                .foregroundStyle(.iLabel.opacity(0.5))
                .visibility(vm.state != .searching)
            
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 42, height: 42)
                    .foregroundStyle(Color.iBackground)
                    .overlay {
                        pinCircleOverlay
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(lineWidth: 2.5)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.iPrimaryDark]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 42, height: 42)
                    }
                
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 4, height: 12)
                    .foregroundStyle(.iPrimary)
                    .visibility(vm.state != .searching)
                    .overlay {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(lineWidth: 1)
                            .frame(width: 4, height: 12)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 2)
            }
            .onChange(of: vm.state, perform: { newState in
                switch newState {
                case .pinning:
                    withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                        isPinAnimating = true
                    }
                default:
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPinAnimating = false
                    }
                }
            })
            .offset(y: offsetY)
        }
    }
    
    private var pinCircleOverlay: some View {
        ZStack {
            // Pinning overlay (white circle)
            pinningOverlay
                .opacity(vm.state == .initial || vm.state == .loading || vm.state == .searching ? 1 : 0)
            
            // Loading overlay (spinner)
            loadingOverlay
                .opacity(vm.state == .pinning ? 1 : 0)
            
            // Waiting overlay (timer)
            if case .waiting(let time, let unit) = vm.state {
                waitingOverlay(time: time, unit: unit)
                    .opacity(1)
            } else if case .steady = vm.state {
                loadingOverlay
            } else {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(Color.clear)
                    .opacity(0)
            }
        }
    }
    
    private var loadingOverlay: some View {
        Circle()
            .frame(width: 28, height: 28)
            .foregroundStyle(Color.clear)
            .overlay {
                LoadingCircleDoubleRunner(size: 24)
            }
    }
    
    private var pinningOverlay: some View {
        Circle()
            .frame(width: 28, height: 28)
            .foregroundStyle(Color.clear)
    }
    
    private func waitingOverlay(time: String, unit: String) -> some View {
        VStack {
            Text(time)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.label)
            
            Text(unit.uppercased())
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.label)
        }
        .frame(height: 48)
    }
}

private struct PinView_Previews: View {
    @StateObject private var vm: PinViewModel = .init()
    var body: some View {
        PinView(vm: vm)
            .onAppear {
                vm.set(state: .steady)
            }
    }
}

#Preview {
    PinView_Previews()
}
