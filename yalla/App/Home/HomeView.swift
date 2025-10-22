//
//  HomeView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 15/10/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core

struct HomeView: View {
    @StateObject
    private var viewModel: HomeViewModel = .init()
    
    var body: some View {
        ZStack {
            Image("image_map_example")
                .resizable()
                .frame(width: UIApplication.shared.screenFrame.width)
                .ignoresSafeArea()
            
            innerBody
        }
    }
    
    var innerBody: some View {
        VStack {
            HomeHeaderView()
                .padding(.horizontal, AppParams.Padding.default)
            
            Spacer()
            
            HomeIdelBottomSheet()
                .padding(.top, 28.scaled)
                .background()
                .cornerRadius(AppParams.Radius.large.scaled, corners: [.topLeft, .topRight])
                .background(
                    RoundedRectangle(cornerRadius: AppParams.Radius.large.scaled)
                        .ignoresSafeArea()
                        .foregroundStyle(Color.background)
                )
        }
    }
}

#Preview {
    HomeView()
}
