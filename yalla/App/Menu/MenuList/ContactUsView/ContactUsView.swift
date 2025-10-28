//
//  ContactUsView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 24/10/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Core

struct ContactUsView: View {
    let appConfigUseCase: any AppConfigUseCase = AppConfigUseCaseImpl()
    
    private var hasPhone: Bool {
        appConfigUseCase.appConfig?.hasPhone ?? false
    }
    
    private var hasTelegram: Bool {
        appConfigUseCase.appConfig?.hasTelegram ?? false
    }
    
    var phoneNumber: String {
        guard hasPhone else {
            return ""
        }
        return appConfigUseCase.appConfig?.setting?.supportPhone ?? ""
    }
    
    var telegram: String {
        guard hasTelegram else {
            return ""
        }
        
        return appConfigUseCase.appConfig?.setting?.supportTelegramNickname ?? ""
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            HStack {
                ContactOptionCard(
                    icon: "icon_telegramm",
                    title: "contact_us_telegram"
                ) {
                    if let url = URL(string: telegram) {
                        UIApplication.shared.open(url)
                    }
                }
                ContactOptionCard(
                    icon: "icon_calling",
                    title: "contact_us_call"
                ) {
                    if let url = URL(string: "tel://\(phoneNumber)") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            
            ContactOptionCard(
                icon: "icon_messages",
                title: "contact_us_support"
            ) {
                if let url = URL(string: "https://t.me/yourusername") {
                    UIApplication.shared.open(url)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .navigationTitle("support.service".localize)
        .navigationBarTitleDisplayMode(.large)

    }
}

#Preview {
    NavigationView {
        ContactUsView()
    }
}
