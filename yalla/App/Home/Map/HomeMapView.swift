//
//  HomeMapView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import MapPack
import SwiftUI
import YallaUtils
import Core

struct HomeMapView: View {
    @StateObject
    private var viewModel: HomeMapViewModel = .init()
    
    @StateObject
    private var valueHolder: HomePropertiesHolder = .shared
    
    @EnvironmentObject
    private var homeModel: HomeViewModel
    
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme
    
    init(viewModel: HomeMapViewModel = .init()) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            map
            actionsView
                .position(
                    x: UIApplication.shared.screenFrame.width / 2,
                    y: UIApplication.shared.screenFrame.height - viewModel.bottomEdge - UIApplication.shared.safeArea.top - UIApplication.shared.safeArea.bottom - 60)
        }
        .onChange(of: viewModel.geoPermission) { newValue in
            guard let newValue else { return }
            debugPrint(newValue.isAuthorized )
        }
        .onChange(of: valueHolder.bottomSheetHeight, perform: { newValue in
            viewModel.setBottomEdge(newValue)
        })
        .onAppear {
            Task {
                try await Task.sleep(for: .milliseconds(400))
                
                viewModel.onAppear()
            }
        }
        .onAppear {
            YallaAlertManager.shared.colorScheme = colorScheme == .dark ? .dark : .light
        }
        .onChange(of: colorScheme) { newValue in
            YallaAlertManager.shared.colorScheme = newValue == .dark ? .dark : .light
        }
    }
    
    private var actionsView: some View {
        HStack {
            Spacer()
            focusButton
                .padding(AppParams.Padding.default.scaled)
        }
        .opacity(!valueHolder.isBottomSheetMinimized ? 1 : 0)
        .animation(.spring(duration: 0.2), value: valueHolder.isBottomSheetMinimized)
    }
    
    private var focusButton: some View {
        FocusLocationButton(
            state: (viewModel.geoPermission?.isAuthorized ?? false) ? .normal : .disabled
        ) {
            viewModel.onClickFocusButton()
        }
    }
    
    private var map: some View {
        UniversalMapView(
            viewModel: viewModel.map
        )
    }
}

#Preview {
    HomeMapView()
        .environmentObject(HomeViewModel())
}
