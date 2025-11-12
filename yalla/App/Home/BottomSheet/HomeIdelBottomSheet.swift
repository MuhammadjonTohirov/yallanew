//
//  HomeIdelBottomSheet.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 22/10/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils
import MapPack

struct HomeIdelBottomSheet: View {
    @StateObject
    var viewModel: HomeIdleSheetViewModel = .init()
    
    @StateObject
    private var valueHolder: HomePropertiesHolder = .shared
    
    @MainActor
    var offsetY: CGFloat {
        valueHolder.isBottomSheetMinimized ? (valueHolder.bottomSheetHeight - 20).limitBottom(0) : 0
    }
    
    @ObservedObject var homeModel: HomeViewModel = .init()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                if let input = self.viewModel.activeService?.headerInput {
                    HomeIdleSheetHeader(input: input)
                        .id(input.image)
                        .padding(.horizontal, 20)
                }
                
                HomeAddressField()
                    .onClick {
                        Task { @MainActor in
                            await homeModel.onClickFromLocation()
                        }
                    }
                    .padding(.horizontal, 20)

                HomeSavedAddressesCard(viewModel: .init())
                    .padding(.horizontal, 20)

                HomeServicesCard(
                    services: self.viewModel.services,
                    onServiceSelected: { service in
                        viewModel.set(activeService: service)
                    }
                )
                .visibility(false)
            }
            .readRect(onRectChange: { rect in
                self.homeModel.setValue(bottomSheetHeight: rect.height)
            })
            .padding(.top, 20.scaled)
            .cornerRadius(AppParams.Radius.large.scaled, corners: [.topLeft, .topRight])
            .background(
                RoundedRectangle(cornerRadius: AppParams.Radius.large.scaled)
                    .ignoresSafeArea()
                    .foregroundStyle(Color.background)
            )
            .vertical(alignment: .bottom)
        }
        .offset(y: self.offsetY)
        .animation(.spring, value: self.offsetY)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    HomeIdelBottomSheet()
}
