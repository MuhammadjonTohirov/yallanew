//
//  LoginView.swift
//  Ildam
//
//  Created by applebro on 22/11/23.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

struct LoginView: View {
    @State private var focus: Bool = false
    @FocusState private var isFocused: Bool
    @StateObject var viewModel: LoginViewModel = .init()
    
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .iPrimaryLite.opacity(1), location: 0),
                .init(color: .iPrimaryDark.opacity(1), location: 1),
            ], center: .top, startRadius: 0, endRadius: 300)
            .ignoresSafeArea()
            
            innerBody
        }
        .navigationDestination(for: AuthRoute.self) { route in
            route.scene
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $viewModel.presentOTP) {
            if let vm = viewModel.otpViewModelForSheet {
                NavigationStack {
                    SecurityCodeInputView(viewModel: vm)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                DismissCircleButton()
                            }
                        }
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(40)
                .interactiveDismissDisabled(false)
            }
        }
        .onAppear {
            viewModel.setNavigator(navigator)
        }
    }
    
    private var innerBody: some View {
        VStack(alignment: .leading) {
            BackCircleButton()
                .colorScheme(.dark)
                .padding(.leading, AppParams.Padding.large)
                .visibility(false)
            
            titleView
                .foregroundStyle(Color.white)
                .padding(AppParams.Padding.large)

            RoundedRectangle(cornerRadius: AppParams.Radius.large)
                .foregroundStyle(Color.background)
                .ignoresSafeArea()
                .overlay {
                    bottomSheet
                        .padding(.horizontal, AppParams.Padding.large)
                        .padding(.top, AppParams.Padding.extraLarge)
                }
        }
    }
    
    private var bottomSheet: some View {
        VStack(spacing: 8) {
            YRoundedTextField {
                HStack {
                    Text("+998".localize)
                        .font(.bodyBaseMedium)
                        .padding(.leading, AppParams.Padding.medium)
                    Divider()
                        .frame(height: 38)
                    YPhoneField(
                        text: $viewModel.phoneNumber,
                        font: .bodyBaseMedium,
                        placeholder: "(__) ___  __  __"
                    )
                }.padding(.horizontal, AppParams.Padding.medium)
                    .frame(height: 50)
            }
            .set(borderColor: !isFocused ? .iBorderDisabled : .label)
            .focused($isFocused)

            Text("login.phone.field.descr".localize) // Мы отправим вам код подтверждения
                .font(.inter(.regular, size: 13))
                .foregroundStyle(Color.iLabelSubtle)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            
            SubmitButtonFactory.primary(title: "next".localize) {
                viewModel.sendOTP()
            }
            .set(isLoading: self.viewModel.isLoading)
            .set(isEnabled: self.viewModel.isValidForm)
            .padding(.bottom, AppParams.Padding.large)
        }
    }
    
    private var titleView: some View {
        VStack(spacing: 0) {
            Text("welcome".localize)
                .font(.titleXLargeBold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("login.title.caption".localize)
                .font(.bodySmallRegular)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LoginView()
        .environmentObject(Navigator())
        .onAppear {
            UserSettings.shared.language = Language.russian.code
        }
}
