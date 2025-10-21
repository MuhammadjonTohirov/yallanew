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
    @StateObject var viewModel: AuthViewModel = .init()
    
    var body: some View {
        NavigationStack {
            innerBody
                .navigationDestination(isPresented: $viewModel.pushRoute) {
                    viewModel.route?.screen
                        .environmentObject(viewModel)
                }
                .onAppear {
                    #if DEBUG
                    self.viewModel.phoneNumber = "00 001-01-0"
                    #endif
                }
        }
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            Text("enter_phone".localize/* Введите номер телефона */)
                .font(.inter(.bold, size: 32))
                .padding(.top, AppParams.Padding.large)
            
            Text("to_send_otp".localize) // Мы отправим вам код подтверждения
                .font(.inter(.regular, size: 13))
                .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                .padding(.bottom, AppParams.Padding.medium)
                .padding(.top, AppParams.Padding.small)

            YRoundedTextField {
                HStack {
                    Text("+998".localize)
                        .font(.inter(.regular, size: 14))
                    YPhoneField(text: $viewModel.phoneNumber, placeholder: "93 123-45-67".localize)
                }.padding(.horizontal, APadding.medium)
            }
            .set(borderColor: viewModel.phoneNumber.isEmpty ? .clear : .secondary)
            
            Spacer()
            
            SubmitButton {
                viewModel.sendOTP()
            } label: {
                Text("next".localize)
            }
            .set(isLoading: self.viewModel.isLoading)
            .set(isEnabled: self.viewModel.isValidForm)
            .padding(.bottom, APadding.default)
        }
        
        .padding(.horizontal, APadding.default)
    }
}

#Preview {
    LoginView()
        .onAppear {
            UserSettings.shared.language = Language.russian.code
        }
}
