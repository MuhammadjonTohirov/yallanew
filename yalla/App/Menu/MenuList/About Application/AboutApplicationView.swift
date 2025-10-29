//
//  AboutApplicationView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 27/10/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils
import IldamSDK

struct AboutApplicationView: View {
    let appConfigUseCase: any AppConfigUseCase = AppConfigUseCaseImpl()

    @Environment(\.dismiss) var dismiss
    @State
    private var startPoint: UnitPoint = .topLeading
    private var hasTelegram: Bool {
        appConfigUseCase.appConfig?.hasTelegram ?? false
    }
    var telegram: String {
        guard hasTelegram else {
            return ""
        }
        
        return appConfigUseCase.appConfig?.setting?.supportTelegramNickname ?? ""
    }
    private var hasInstagram: Bool {
        appConfigUseCase.appConfig?.hasInstagram ?? false
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .iPrimaryLite.opacity(1), location: 0),
                .init(color: .iPrimaryDark.opacity(1), location: 1),
            ], center: startPoint, startRadius: 0, endRadius: 300)
            .ignoresSafeArea()
            
            VStack {
                headerView
                    
                containView
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private var headerView: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                SubmitButton(
                    backgroundColor: Color.iBackgroundSecondary) {
                        
                        Image("icon_backarrow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)

                    }
                action: {
                    dismiss()
                }
            }
            .frame(width: 42, height: 42)
            .cornerRadius(21, corners: .allCorners)
            .horizontal(alignment: .leading)
            .padding(.leading)
            
                Image("splash_logo")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 80)
            
                    
            VStack(spacing: 4) {
                
                Text("yalla".localize)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text(verbatim: "Version: 1.21")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .vertical(alignment: .bottom)
            
        }
        .frame(height: 260)
        .padding(.bottom,20)
    }
    
    private var footer: some View {
        VStack(alignment: .leading) {
            
            Text("about.app".localize)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.iLabel)
                .padding(.vertical)
            
           VStack(spacing: 0) {
               rowItem(title: "privacy.policy".localize)
               Divider()
               rowItem(title: "user.agreement".localize)
            }
           .background(
               RoundedRectangle(cornerRadius: 16)
                   .fill(Color(UIColor.iBackgroundSecondary))
           )
           .padding(.horizontal,5)
            
            Text("social.networks".localize)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.iLabel)
                .padding(.vertical)

            VStack(spacing: 0) {
               rowItem(icon: "image_instagramm", title: "Instagram")
                
               Divider()
                
               rowItem(icon: "image_telegramm", title: "Telegram")
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.iBackgroundSecondary))
            )
            .padding(.horizontal,5)

            Spacer()
            
            SubmitButton(backgroundColor: Color.iPrimary, height: 60) {
                Text("rate.app".localize)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading)
            }
            action: {
                
            }
            .padding(.horizontal,5)
            .padding(.vertical)


        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    private var containView: some View {
        Rectangle()
            .transition(.push(from: .bottom).combined(with: .identity))
            .foregroundStyle(Color.background)
            .cornerRadius(40, corners: [.topLeft, .topRight])
            .overlay(content: {
                footer
            })
            .ignoresSafeArea()
        
    }
    
    func rowItem(icon: String? = nil, title: String) -> some View {
        Button(action: {
            // Handle action here
        }) {
            HStack(spacing: 20) {
                if let icon = icon {
                    Image(icon)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
        
                    // Title
                    Text(title.localize)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.iLabel)
                        .lineLimit(1)
                 

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
    
    private func openTelegram() {
        let telegram = appConfigUseCase.appConfig?.setting?.supportTelegramNickname ?? ""
        UIApplication.shared.open(URL(string: telegram)!)
    }
    
    private func openInstagram() {
        let instagram = appConfigUseCase.appConfig?.setting?.supportInstagramNickname ?? ""
        
        UIApplication.shared.open(URL(string: instagram)!)
    }
    
    
}

#Preview {
    NavigationStack {
        AboutApplicationView()
    }
}
