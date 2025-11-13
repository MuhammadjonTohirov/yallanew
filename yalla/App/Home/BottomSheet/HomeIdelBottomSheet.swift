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
import YallaSlidingSheet

struct HomeIdelBottomSheet: View {
    @StateObject
    var viewModel: HomeIdleSheetViewModel = .init()
    
    @StateObject
    private var valueHolder: HomePropertiesHolder = .shared
    
    var offsetY: CGFloat {
        valueHolder.isBottomSheetMinimized ? (valueHolder.bottomSheetHeight - 20).limitBottom(0) : 0
    }
    
    @ObservedObject var homeModel: HomeViewModel = .init()
    
    @State
    private var progress: CGFloat = 0
    @State
    private var isExpanded: Bool = false
    
    @State
    private var isViewReady: Bool = false
    
    var body: some View {
        ZStack {
            idleStateView
            
//            if valueHolder.bottomSheetHeight > 20 {
//                YallaSlidingSheet(
//                    minHeight: valueHolder.bottomSheetHeight + 90,
//                    progress: $progress,
//                    backgroundColor: Color.black.opacity(0.1),
//                    shadowOpacity: 0.05,
//                    cornerRadius: 38,
//                    animationDuration: 0.2,
//                    setOffsetAnimation: nil,
//                    isExpanded: $isExpanded,
//                    firstView: {
//                        VStack {
//                            Text("Taxi Services List")
//                            
//                            Spacer()
//                        }
//                    }, secondView: {
//                        VStack {
//                            ForEach(0..<100) { id in
//                                Text("Item \(id)")
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                        .opacity(progress > 0.2 ? 1 : 0)
//                    }
//                )
//            }
        }
    }
    
    var idleStateView: some View {
        idleStateBody
        .padding(.top, 20.scaled)
        .cornerRadius(AppParams.Radius.large.scaled, corners: [.topLeft, .topRight])
        .background(
            RoundedRectangle(cornerRadius: AppParams.Radius.large.scaled)
                .ignoresSafeArea()
                .foregroundStyle(Color.background)
        )
        .vertical(alignment: .bottom)
        .offset(y: self.offsetY)
        .onAppear {
            viewModel.onAppear()
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    private var idleStateBody: some View {
        VStack(spacing: 10) {
            if let input = self.viewModel.activeService?.headerInput {
                HomeIdleSheetHeader(input: input)
                    .id(input.image)
                    .padding(.horizontal, 20)
            }
            
            HomeIdleAddressField(
                onWhereToGo: {
                    Task { @MainActor in
                        await homeModel.onClickToButton()
                    }
                },
                onLetsGo: {
                    debugPrint("Lets go")
                }
            )
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
    }
}

#Preview {
    ZStack {
        Color.iBackgroundSecondary.ignoresSafeArea()
        HomeIdelBottomSheet()
    }
}
