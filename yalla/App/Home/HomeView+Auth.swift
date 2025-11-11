//
//  HomeView+Auth.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 07/11/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

extension HomeView {
    var authRequiredSheet: some View {
        VStack(spacing: 18.scaled) {
            Image("icon_user_add")
                .resizable()
                .frame(width: 250.scaled, height: 250.scaled)
            
            VStack(spacing: 12.scaled) {
                Text("login.req.title".localize)
                    .font(.bodyLargeBold)
                    .foregroundStyle(.iLabel)
                
                Text("login.req.descr".localize)
                    .font(.bodyBaseBold)
                    .foregroundStyle(.iLabelSubtle)
            }
            
            SubmitButtonFactory.primary(title: "auth".localize) {
                Task { @MainActor in
                    await viewModel.showAuth()
                }
            }
            .padding([.horizontal], AppParams.Padding.default.scaled)
            .padding(.top, AppParams.Padding.extraLarge.scaled)
        }
        .multilineTextAlignment(.center)

    }
}
