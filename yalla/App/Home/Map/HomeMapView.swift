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
    
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme
    
    init(viewModel: HomeMapViewModel = .init()) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            map
            sheetHeader
        }
        .onChange(of: viewModel.geoPermission) { newValue in
            guard let newValue else { return }
            debugPrint(newValue.isAuthorized )
        }
        .onAppear {
            viewModel.setup()
            Task {
                try await Task.sleep(for: .milliseconds(400))
                
                viewModel.focusToCurrentLocation()
            }
        }
        .onAppear {
            YallaAlertManager.shared.colorScheme = colorScheme == .dark ? .dark : .light
            
            
        }
        .onChange(of: colorScheme) { newValue in
            YallaAlertManager.shared.colorScheme = newValue == .dark ? .dark : .light
        }
    }
    
    private var sheetHeader: some View {
        HStack {
            Spacer()
            focusButton
                .padding(AppParams.Padding.default.scaled)
        }
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
}
