//
//  SideMenuView.swift
//  Ildam
//
//  Created by applebro on 10/12/23.
//

import Foundation
import SwiftUI
import Core
import YallaUtils
import Kingfisher

struct SideMenuBody: View {
    @ObservedObject var viewModel: SideMenuViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: 10) {
                userInfo
                    .onClick {
                        Task { @MainActor in
                            viewModel.onClick(menu: .profile)
                        }
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )

                sectionOne
                
                sectionTwo
                
                sectionThree
            }
            .padding()
            .scrollable(axis: .vertical)
            .onAppear {
                Task { @MainActor in
                    await viewModel.onAppear()
                }
            }
        }
    }
    
    private var userInfo: some View {
        ZStack {
            HStack {
                Circle()
                    .frame(width: 38, height: 38)
                    .foregroundStyle(.iBackgroundTertiary)
                    .overlay {
                        Image("icon_backarrow")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.iLabel)
                            .frame(width: 16, height: 16)
                    }
                    .onClick {
                        dismiss.callAsFunction()
                    }
                    .padding(AppParams.Padding.default)
                Spacer()
                Circle()
                    .frame(width: 38, height: 38)
                    .foregroundStyle(.iBackgroundTertiary)
                    .overlay {
                        Image("icon_brush")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.iLabel)
                            .frame(width: 22, height: 22)
                    }
                    .onClick {
                        
                    }
                    .padding(AppParams.Padding.default)
            }
            .vertical(alignment: .top)
            VStack {
                KFImage(UserSettings.shared.userInfo?.imageURL)
                    .placeholder {
                        Circle()
                            .frame(width: 80.scaled, height: 80.scaled)
                            .foregroundStyle(Color.iBackgroundTertiary)
                            .overlay(content: {
                                Image("icon_user")
                                    .renderingMode(.template)
                                    .foregroundStyle(.iLabel)
                            })
                    }
                    .resizable()
                    .frame(width: 80.scaled, height: 80.scaled)
                    .clipShape(Circle())
                
                VStack(alignment: .center, spacing: 2) {
                    Text(UserSettings.shared.userInfo?.fullName ?? "Guest")
                        .font(.titleLargeBold)
                        .foregroundStyle(Color.iLabel)

                    Text(UserSettings.shared.userInfo?.formattedPhone ?? "+998 (91) 123-45-67")
                        .font(.bodySmallMedium)
                        .foregroundStyle(Color.iLabel)
                }
            }
            .padding(.vertical, AppParams.Padding.large)
        }
        .background(content: {
            RoundedRectangle(cornerRadius: AppParams.Radius.medium)
                .fill(Color.iBackgroundSecondary)
        })
    }
    
    private var sectionOne: some View {
        VStack(spacing: 0) {
            paymentTypeRow()
                .padding(.horizontal, AppParams.Padding.default)
                .onClick {
                    viewModel.onClick(menu: .paymentMethods)
                }
            
            divider
            
            
            bonusesRow()
            .padding(.horizontal, AppParams.Padding.default)
            .onClick {
                viewModel.onClick(menu: .bonuses)
            }
            .visibility(viewModel.isDiscountVisible)
        }
        .background {
            RoundedRectangle(cornerRadius: AppParams.Padding.default)
                .foregroundStyle(Color.iBackgroundSecondary)
        }
    }
    
    private var sectionTwo: some View {
        VStack(spacing: 0) {
            row(icon: Image("icon_task"), title: "journey.history".localize)
                .padding(.horizontal, AppParams.Padding.default)
                .onClick {
                    viewModel.onClick(menu: .history)
                }
            
            divider
            
            // Мои места
            row(icon: Image("icon_location_tick"), title: "my.places".localize)
                .padding(.horizontal, AppParams.Padding.default)
                .onClick {
                    viewModel.onClick(menu: .places)
                }

            // Пригласите близких
            row(
                icon: Image("icon_add_user"),
                title: "invite.friends".localize
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onClick {
                viewModel.onClick(menu: .invite)
            }
            .visibility(false)
            
            // Стать водителем
            row(
                icon: Image("icon_drive"),
                title: "become.driver".localize
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onClick {
                viewModel.onClick(menu: .driver)
            }
            .visibility(false)
            
            divider
            
            // Связаться с нами
            row(
                icon: Image("icon_chat"),
                title: "contact.us".localize
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onClick {
                viewModel.onClick(menu: .contactus)
            }
            
            divider
            
            // Связаться с нами
            row(
                icon: Image("icon_notification"),
                title: "news.and.notifs".localize
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onClick {
                viewModel.onClick(menu: .notification)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: AppParams.Padding.default)
                .foregroundStyle(Color.iBackgroundSecondary)
        }
    }
    
    private var divider: some View {
        Divider().padding(.leading, 50.scaled)
            .foregroundStyle(.iBorderDisabled)
    }
    
    private var sectionThree: some View {
        VStack {
            // Настройки
            row(icon: Image("icon_setting2"), title: "settings".localize)
                .padding(.horizontal, AppParams.Padding.default)
                .onClick {
                    viewModel.onClick(menu: .settings)
                }
            
            divider
            
            // О приложении
            row(icon: Image("icon_logo"), title: "about.app".localize)
                .padding(.horizontal, AppParams.Padding.default)
                .onClick {
                    viewModel.onClick(menu: .aboutus)
                }
        }
        .background {
            RoundedRectangle(cornerRadius: AppParams.Padding.default)
                .foregroundStyle(Color.iBackgroundSecondary)
        }
    }
    
    private func row(icon: Image, title: String, detail: String? = nil, renderingMode: Image.TemplateRenderingMode = .template) -> some View {
        HStack(spacing: 10) {
            icon
                .renderingMode(renderingMode)
                .foregroundStyle(Color.label)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyLargeMedium)
                    .foregroundStyle(Color.label)
                
                if let detail {
                    Text(detail)
                        .font(.bodyCaptionMedium)
                        .foregroundStyle(Color.init(uiColor: .label))
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
        }
        .frame(height: 60)
        .overlay {
            Rectangle()
                .foregroundStyle(Color.background.opacity(0.01))
        }
    }
    
    private func bonusesRow() -> some View {
        HStack(spacing: 10) {
            Image("icon_gold_coin")
            
            VStack(alignment: .leading, spacing: 2) {
                Text("payment.methods".localize)
                    .font(.bodyLargeMedium)
                    .foregroundStyle(Color.label)
                
                Text("promocode".localize)
                    .font(.bodyCaptionMedium)
                    .foregroundStyle(Color.init(uiColor: .label))
            }
            Spacer()
            
            HStack(spacing: 3) {
                Text(verbatim: "0")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(4.scaled)
            .padding(.horizontal, 9.scaled)
            .background {
                Capsule()
                    .foregroundStyle(
                        LinearGradient(colors: [.red, .iPrimaryDark], startPoint: .leading, endPoint: .trailing)
                    )
            }
        }
        .frame(height: 60)
        .overlay {
            Rectangle()
                .foregroundStyle(Color.background.opacity(0.01))
        }
    }
    
    private func paymentTypeRow() -> some View {
        HStack(spacing: 10) {
            Image("icon_cash3d")
            
            VStack(alignment: .leading, spacing: 2) {
                Text("payment.methods".localize)
                    .font(.bodyLargeMedium)
                    .foregroundStyle(Color.label)
                
                Text(viewModel.paymentMethod)
                    .font(.bodyCaptionMedium)
                    .foregroundStyle(Color.init(uiColor: .label))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
        }
        .frame(height: 60)
        .overlay {
            Rectangle()
                .foregroundStyle(Color.background.opacity(0.01))
        }
    }
}

#Preview {
    SideMenuBody(viewModel: .init())
}
