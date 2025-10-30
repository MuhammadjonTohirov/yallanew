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
    @StateObject var viewModel: SideMenuViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: 10) {
                userInfo
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )

                sectionOne
                    .clipShape(RoundedRectangle(cornerRadius: AppParams.Radius.default))
                
                sectionTwo
                    .clipShape(RoundedRectangle(cornerRadius: AppParams.Radius.default))
                
                sectionThree
                    .clipShape(RoundedRectangle(cornerRadius: AppParams.Radius.default))
                
                becomeDriverRow
            }
            .padding()
            .scrollable(axis: .vertical)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private var userInfo: some View {
        ZStack {
            HStack {
                Circle()
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
                    .frame(width: 38, height: 38)
                    .padding(AppParams.Padding.default)
                Spacer()
                Circle()
                    .foregroundStyle(.iBackgroundTertiary)
                    .overlay {
                        Image("icon_brush")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.iLabel)
                            .frame(width: 22, height: 22)
                    }
                    .onClick {
                        Task { @MainActor in
                            viewModel.onClick(menu: .profile)
                        }
                    }
                    .frame(width: 38, height: 38)
                    .padding(AppParams.Padding.default)
            }
            .vertical(alignment: .top)
            VStack {
                KFImage(viewModel.userInfo?.imageURL)
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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80.scaled, height: 80.scaled)
                    .clipShape(Circle())
                
                VStack(alignment: .center, spacing: 2) {
                    Text(viewModel.userInfo?.fullName ?? "Guest")
                        .font(.titleLargeBold)
                        .foregroundStyle(Color.iLabel)

                    Text(viewModel.userInfo?.formattedPhone ?? "+998 (91) 123-45-67")
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
                .onTapped(.iBackgroundSecondary) {
                    viewModel.onClick(menu: .paymentMethods)
                }
            
            divider
            
            
            bonusesRow()
            .padding(.horizontal, AppParams.Padding.default)
            .onTapped(.iBackgroundSecondary) {
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
                .onTapped(.iBackgroundSecondary) {
                    viewModel.onClick(menu: .history)
                }
            
            divider
            
            // Мои места
            row(icon: Image("icon_location_tick"), title: "my.places".localize)
                .padding(.horizontal, AppParams.Padding.default)
                .onTapped(.iBackgroundSecondary) {
                    viewModel.onClick(menu: .places)
                }

            // Пригласите близких
            row(
                icon: Image("icon_add_user"),
                title: "invite.friends".localize
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onTapped(.iBackgroundSecondary) {
                viewModel.onClick(menu: .invite)
            }
            .visibility(false)
            
            divider
            
            // Связаться с нами
            row(
                icon: Image("icon_chat"),
                title: "contact.us".localize
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onTapped(.iBackgroundSecondary) {
                viewModel.onClick(menu: .contactus)
            }
            
            divider
            
            // Связаться с нами
            row(
                icon: Image("icon_notification"),
                title: "news.and.notifs".localize,
                rightView: AnyView(
                    Circle()
                        .foregroundStyle(Color.init(uiColor: .systemRed))
                        .frame(width: 24, height: 24)
                        .overlay {
                            Text(verbatim: "0".localize)
                                .foregroundStyle(.white)
                                .font(.bodySmallBold)
                        }
                )
            )
            .padding(.horizontal, AppParams.Padding.default)
            .onTapped(.iBackgroundSecondary) {
                viewModel.onClick(menu: .notification)
            }
            
        }
        .background {
            RoundedRectangle(cornerRadius: AppParams.Padding.default)
                .foregroundStyle(Color.iBackgroundSecondary)
        }
    }
    
    private var becomeDriverRow: some View {
        Image("img_become_driver_bg")
            .resizable()
            .frame(height: 64)
            .overlay {
                ZStack {
                    Image("img_become_driver")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 64)
                        .horizontal(alignment: .leading)
                    
                    Text("become.driver".localize)
                        .font(.titleBaseBold)
                        .foregroundStyle(.white)
                    

                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .bold))
                        .horizontal(alignment: .trailing)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
            .cornerRadius(16, corners: .allCorners)
            .onTapped(.iBackgroundSecondary) {
                viewModel.onClick(menu: .driver)
            }
    }
    
    private var divider: some View {
        Divider().padding(.leading, 50.scaled)
            .foregroundStyle(.iBorderDisabled)
    }
    
    private var sectionThree: some View {
        VStack(spacing: 0) {
            // Настройки
            row(icon: Image("icon_setting2"), title: "settings".localize)
                .padding(.horizontal, AppParams.Padding.default)
                .onTapped(.iBackgroundSecondary) {
                    viewModel.onClick(menu: .settings)
                }
            
            divider
            
            // О приложении
            row(icon: Image("icon_logo"), title: "about.app".localize)
                .padding(.horizontal, AppParams.Padding.default)
                .onTapped(.iBackgroundSecondary) {
                    viewModel.onClick(menu: .aboutus)
                }
        }
        .background {
            RoundedRectangle(cornerRadius: AppParams.Padding.default)
                .foregroundStyle(Color.iBackgroundSecondary)
        }
    }
    
    private func row(
        icon: Image,
        title: String,
        detail: String? = nil,
        renderingMode: Image.TemplateRenderingMode = .template,
        rightView: (AnyView)? = nil
    ) -> some View {
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
            
            if let rightView {
                rightView
            }
            
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
                Text("bonus.and.discounts".localize)
                    .font(.bodyLargeMedium)
                    .foregroundStyle(Color.label)
                
                Text("promocode".localize)
                    .font(.bodyCaptionMedium)
                    .foregroundStyle(Color.init(uiColor: .label))
            }
            Spacer()
            
            HStack(spacing: 3) {
                Text(viewModel.bonusValue)
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
        row(
            icon: .init("icon_cash3d"),
            title: "payment.methods".localize,
            renderingMode: .original
        )
    }
}

#Preview {
    SideMenuBody(viewModel: .init())
}
