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
import SwiftMessages

struct AboutApplicationView: View {
    let appConfigUseCase: any AppConfigUseCase = AppConfigUseCaseImpl()
    private let appRatingUseCase: AppRatingUseCase = AppRatingUseCaseImpl.shared
        
    private var policyUrl: String {
        let ruUrl = appConfigUseCase.appConfig?.setting?.privacyPolicyRu ?? "https://ildam.uz/privacy-policy"
        let uzUrl = appConfigUseCase.appConfig?.setting?.privacyPolicyUz ?? "https://ildam.uz/privacy-policy"
        
        return UserSettings.shared.language == Language.uzbek.code ? uzUrl : ruUrl
    }
    
    @Environment(\.dismiss) var dismiss
    @State
    private var startPoint: UnitPoint = .topLeading
    
    @State
    private var showPrivacyPolicy = false // unused now; kept for potential in-app webview
    
    @State
    private var isLoading: Bool = false
    
    private var hasTelegram: Bool {
        appConfigUseCase.appConfig?.hasTelegram ?? false
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
            
            headerView
                .vertical(alignment: .top)
            
            containView
                .vertical(alignment: .bottom)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .center, spacing: 40.scaled) {
            Image("splash_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160.scaled, height: 89.scaled)
            
            VStack(spacing: 4.scaled) {
                Text("yalla".localize)
                    .font(.titleLargeBold)
                    .foregroundColor(.white)
                
                Text(verbatim: "Version: 1.21")
                    .font(.bodySmallMedium)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
    
    private var footer: some View {
        VStack(alignment: .leading, spacing: 16) {
            // About section
            Text("about.app".localize)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.iLabel)
                .padding(.leading)

            VStack(spacing: 0) {
                rowItem(title: "privacy.policy".localize)
                    .onTapped(Color.iBackgroundSecondary, action: {
                        openPolicy()
                    })

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.iBackgroundSecondary)
                    .overlay {
                        Divider()
                            .padding(.horizontal)
                    }

                rowItem(title: "user.agreement".localize)
                    .onTapped(Color.iBackgroundSecondary, action: {
                        openPolicy()
                    })
            }
            .background(Color.iBackgroundSecondary)
            .cornerRadius(16, corners: .allCorners)
            .padding(.horizontal, 20)
            .frame(height: 120)

            // Social section
            Text("social.networks".localize)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.iLabel)
                .padding(.top, 8)
                .padding(.leading)

            VStack(spacing: 0) {
                rowItem(icon: "image_instagramm", title: "Instagram")
                
                    .onTapped(Color.iBackgroundSecondary, action: {
                        openInstagram() 
                    })

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.iBackgroundSecondary)
                    .overlay {
                        Divider()
                            .padding(.horizontal)
                    }
                
                rowItem(icon: "image_telegramm", title: "Telegram")
                    .onTapped(Color.iBackgroundSecondary, action: {
                        openTelegram()
                    })
 
            }
            .background(Color.iBackgroundSecondary)
            .cornerRadius(16, corners: .allCorners)
            .padding(.horizontal, 20)
            .frame(height: 120)

            SubmitButton(backgroundColor: Color.iPrimary, height: 60) {
                Text("rate.app".localize)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading)
            }
            action: {
                appRatingUseCase.requestReview()
            }
            .padding(.horizontal, 20)
            .padding(.top,AppParams.Padding.large)
        }
    }
    
    private var containView: some View {
        footer
            .padding(.top, 32.scaled)
            .background {
                RoundedRectangle(cornerRadius: AppParams.Radius.large.scaled)
                    .ignoresSafeArea()
                    .foregroundStyle(Color.background)
            }
    }
    
    func rowItem(icon: String? = nil, title: String) -> some View {
        HStack(spacing: 6.scaled) {
            if let icon = icon {
                Image(icon)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }

            Text(title)
                .font(.bodyLargeMedium)
                .foregroundColor(.iLabel)
                .lineLimit(1)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.iLabel.opacity(0.4))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private func openTelegram() {
        let raw = appConfigUseCase.appConfig?.setting?.supportTelegramNickname ?? ""
        let username: String
        if raw.hasPrefix("http"), let url = URL(string: raw), let last = url.pathComponents.last, !last.isEmpty {
            username = last
        } else if raw.hasPrefix("@") {
            username = String(raw.dropFirst())
        } else if raw.hasPrefix("t.me/") {
            username = String(raw.dropFirst(5))
        } else {
            username = raw
        }

        guard !username.isEmpty else {
            Snackbar.show(message: "no_telegram".localize, theme: .error)
            return
        }

        if let appURL = URL(string: "tg://resolve?domain=\(username)"), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = URL(string: "https://t.me/\(username)") {
            UIApplication.shared.open(webURL)
        } else {
            Snackbar.show(message: "no_telegram".localize, theme: .error)
        }
    }
    
    private func openInstagram() {
        let raw = appConfigUseCase.appConfig?.setting?.supportInstagramNickname ?? ""
        let username: String
        if raw.hasPrefix("http"), let url = URL(string: raw), let last = url.pathComponents.last, !last.isEmpty {
            username = last
        } else if raw.hasPrefix("@") {
            username = String(raw.dropFirst())
        } else if raw.contains("instagram.com/") {
            if let range = raw.range(of: "instagram.com/") {
                username = String(raw[range.upperBound...])
            } else {
                username = raw
            }
        } else {
            username = raw
        }

        guard !username.isEmpty else {
            Snackbar.show(message: "no_instagram".localize, theme: .error)
            return
        }

        if let appURL = URL(string: "instagram://user?username=\(username)"), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = URL(string: "https://instagram.com/\(username)") {
            UIApplication.shared.open(webURL)
        } else {
            Snackbar.show(message: "no_instagram".localize, theme: .error)
        }
    }

    private func openPolicy() {
        guard !policyUrl.isEmpty, let url = URL(string: policyUrl) else {
            Snackbar.show(message: "no_policy_url".localize, theme: .error)
            return
        }
        UIApplication.shared.open(url)
    }
}

#Preview {
    NavigationStack {
        AboutApplicationView()
    }
}
