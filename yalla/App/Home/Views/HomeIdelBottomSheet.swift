//
//  HomeIdelBottomSheet.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 22/10/25.
//

import Foundation
import SwiftUI

struct HomeIdelBottomSheet: View {
    var body: some View {
        VStack(spacing: 10) {
            HomeAddressField()
            
            HomeSavedAddressesCard(viewModel: .init())
            
            HomeServicesCard(
                services: [
                    .init(title: "Межгород", backgroundImageName: "img_bg_intercity"),
                    .init(title: "Почта", backgroundImageName: "img_bg_post"),
                    .init(title: "Доставка", backgroundImageName: "img_bg_delivery")
                ],
                onServiceSelected: { _ in }
            )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    HomeIdelBottomSheet()
}
