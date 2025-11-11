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
    
    @ObservedObject var homeModel: HomeViewModel = .init()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HomeAddressField()
                    .onClick {
                        Task { @MainActor in
                            await homeModel.onClickFromLocation()
                        }
                    }
                
                HomeSavedAddressesCard(viewModel: .init())
                
                HomeServicesCard(
                    services: [
                        .init(title: "Межгород", backgroundImageName: "img_bg_intercity", logoImageName: "img_pins_left"),
                        .init(title: "Почта", backgroundImageName: "img_bg_post", logoImageName: "img_mail_left"),
                        .init(title: "Доставка", backgroundImageName: "img_bg_delivery", logoImageName: "img_box_left"),
                        .init(title: "taxi".localize, backgroundImageName: "img_bg_taxi", logoImageName: "img_car_left"),
                    ],
                    onServiceSelected: { _ in }
                )
            }
            .readRect(onRectChange: { rect in
                self.homeModel.map?.setBottomEdge(rect.height)
            })
            .padding(.top, 28.scaled)
            .padding(.horizontal, 20)
            .cornerRadius(AppParams.Radius.large.scaled, corners: [.topLeft, .topRight])
            .background(
                RoundedRectangle(cornerRadius: AppParams.Radius.large.scaled)
                    .ignoresSafeArea()
                    .foregroundStyle(Color.background)
            )
            .vertical(alignment: .bottom)
        }
    }
}

#Preview {
    HomeIdelBottomSheet()
}
