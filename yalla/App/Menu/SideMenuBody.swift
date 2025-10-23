//
//  SideMenuView.swift
//  Ildam
//
//  Created by applebro on 10/12/23.
//

//import Foundation
//import SwiftUI
//import Core
//import YallaUtils
//import Kingfisher
//
//struct SideMenuBody: View {
//    @ObservedObject var viewModel: SideMenuViewModel
//    
//    var body: some View {
//        ZStack {
//            Color.background.ignoresSafeArea()
//            VStack(spacing: 10) {
//                VStack {
//                    userInfo
//                        .onClick {
//                            viewModel.onClick(menu: .profile)
//                        }
//                        .clipShape(
//                            RoundedRectangle(cornerRadius: 30)
//                        )
//
//                    sectionOne
//                    
//                    sectionTwo
//                    
//                    sectionThree
//                }
//                .background {
//                    RoundedRectangle(cornerRadius: 30)
//                        .foregroundStyle(.secondary)
//                }
//            }
//            .scrollable(axis: .vertical)
//            .onAppear {
//                viewModel.onAppear()
//            }
//        }
//    }
//    
//    private var userInfo: some View {
//        HStack {
//            KFImage(UserSettings.shared.userInfo?.imageURL)
//                .placeholder {
//                    Image("image_placeholder")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 60, height: 600)
//                }
//                .resizable()
//                .scaledToFill()
//                .frame(width: 60, height: 60)
//                .clipShape(Circle())
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(UserSettings.shared.userInfo?.fullName ?? "")
//                    .font(.inter(.medium, size: 16))
//                    .foregroundStyle(Color.label)
//
//                Text(UserSettings.shared.userInfo?.formattedPhone ?? "")
//                    .font(.inter(.regular, size: 12))
//                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
//            }
//            
//            Spacer()
//        }
//        .padding(AppParams.Padding.default)
//    }
//    
//    private var sectionOne: some View {
//        VStack(spacing: 0) {
//            row(icon: Image("icon_history"), title: "journey.history".localize)
//                .padding(.horizontal, AppParams.Padding.default)
//                .onClick {
//                    viewModel.onClick(menu: .history)
//                }
//
//            // Мои места
//            row(icon: Image("icon_map"), title: "my.places".localize)
//                .padding(.horizontal, AppParams.Padding.default)
//                .onTapped(.background) {
//                    viewModel.onClick(menu: .places)
//                }
//
//            // Бонусы и скидки, У вас 70 000 сум кэшбека
//            row(
//                icon: Image("icon_coin"),
//                title: "bonus.and.discounts".localize,
//                detail: viewModel.bonusValue,
//                renderingMode: .original
//            )
//            .padding(.horizontal, AppParams.Padding.default)
//            .onTapped(.background) {
//                viewModel.onClick(menu: .bonuses)
//            }
//            .visibility(viewModel.isDiscountVisible)
//
//            // Способ оплаты, Наличние
//            paymentTypeRow()
//                .padding(.horizontal, AppParams.Padding.default)
//                .onTapped(.background) {
//                    viewModel.onClick(menu: .paymentMethods)
//                }
//        }
//        .background {
//            RoundedRectangle(cornerRadius: 30)
//                .foregroundStyle(Color.init(uiColor: .systemBackground))
//        }
//        .clipShape(
//            RoundedRectangle(cornerRadius: 30)
//        )
//    }
//    
//    private var sectionTwo: some View {
//        VStack(spacing: 0) {
//            // Пригласите близких
//            row(
//                icon: Image("icon_add_user"),
//                title: "invite.friends".localize
//            )
//            .padding(.horizontal, AppParams.Padding.default)
//            .onClick {
//                viewModel.onClick(menu: .invite)
//            }
//            // Стать водителем
//            row(
//                icon: Image("icon_drive"),
//                title: "become.driver".localize
//            )
//            .padding(.horizontal, AppParams.Padding.default)
//            .onClick {
//                viewModel.onClick(menu: .driver)
//            }
//            
//            // Связаться с нами
//            row(
//                icon: Image("icon_call"),
//                title: "contact.us".localize
//            )
//            .padding(.horizontal, AppParams.Padding.default)
//            .onTapped(.background) {
//                viewModel.onClick(menu: .contactus)
//            }
//            
//            // Связаться с нами
//            row(
//                icon: Image("icon_bell"),
//                title: "news.and.notifs".localize
//            )
//            .padding(.horizontal, AppParams.Padding.default)
//            .onClick {
//                viewModel.onClick(menu: .notification)
//            }
//        }
//        .background {
//            RoundedRectangle(cornerRadius: 30)
//                .foregroundStyle(Color.init(uiColor: .systemBackground))
//        }
//        .clipShape (
//            RoundedRectangle(cornerRadius: 30)
//        )
//    }
//    
//    private var sectionThree: some View {
//        VStack {
//            // Настройки
//            row(icon: Image("icon_settings"), title: "settings".localize)
//                .padding(.horizontal, AppParams.Padding.default)
//                .onClick {
//                    viewModel.onClick(menu: .settings)
//                }
//            // О приложении
//            row(icon: Image("icon_info"), title: "about.app".localize)
//                .padding(.horizontal, AppParams.Padding.default)
//                .onClick {
//                    viewModel.onClick(menu: .aboutus)
//                }
//        }
//        .background {
//            RoundedRectangle(cornerRadius: 30)
//                .foregroundStyle(Color.init(uiColor: .systemBackground))
//        }
//        .clipShape (
//            RoundedRectangle(cornerRadius: 30)
//        )
//    }
//    
//    private func row(icon: Image, title: String, detail: String? = nil, renderingMode: Image.TemplateRenderingMode = .template) -> some View {
//        HStack(spacing: 10) {
//            icon
//                .renderingMode(renderingMode)
//                .foregroundStyle(Color.label)
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.inter(.medium, size: 16))
//                    .foregroundStyle(Color.label)
//                
//                if let detail {
//                    Text(detail)
//                        .font(.inter(.regular, size: 12))
//                        .foregroundStyle(Color.init(uiColor: .secondaryLabel))
//                }
//            }
//            Spacer()
//        }
//        .frame(height: 60)
//        .overlay {
//            Rectangle()
//                .foregroundStyle(Color.background.opacity(0.01))
//        }
//    }
//    
//    private func paymentTypeRow() -> some View {
//        HStack(spacing: 10) {
//            Image("icon_cash3d")
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text("payment.methods".localize)
//                    .font(.inter(.medium, size: 16))
//                    .foregroundStyle(Color.label)
//                
//                Text(viewModel.paymentMethod)
//                    .font(.inter(.regular, size: 12))
//                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
//            }
//            Spacer()
//        }
//        .frame(height: 60)
//        .overlay {
//            Rectangle()
//                .foregroundStyle(Color.background.opacity(0.01))
//        }
//    }
//}
//
//#Preview {
//    SideMenuBody(viewModel: .init())
//}
