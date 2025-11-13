//
//  HomeMapViewModel+Alert.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation
import YallaUtils
import SwiftUI
import Core

extension HomeMapViewModel {
    func alertLocationPermissionRequired() {
        YallaAlertManager.shared.showAlert(
            customContent: AnyView(
                VStack(spacing: 10.scaled) {
                    Image("img_pin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 190.scaled)
                        .padding(.top, 24.scaled)
                        .padding(.bottom, 16.scaled)
                    
                    Text("enabel.location".localize)
                        .font(.bodyLargeBold)
                        .foregroundStyle(.iLabel)
                    
                    Text("enable.location.detail".localize)
                        .font(.bodySmallMedium)
                        .foregroundColor(Color.iLabelSubtle)
                        .multilineTextAlignment(.center)
                }
                    .padding(.vertical, 10)
            ),
            buttons: [
                PrimaryAlertButton(title: "allow".localize, action: { [weak self] in
                    YallaAlertManager.shared.dismiss()
                    
                    self?.navigateToSettings()
                })
            ]
        )
    }
    
    private func navigateToSettings() {
//        show app settings
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
