//
//  OTPView.swift
//  Ildam
//
//  Created by applebro on 23/11/23.
//

import Foundation
import SwiftUI
import YallaUtils
import Core
import Combine

struct SecurityCodeInputView: View {
    @StateObject var viewModel: OTPViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var otpFieldFocus: Bool
    @State private var code: [String] = []
    @State private var secondsRemaining = 59
    
    @State private var errorMessage: String?
    @State private var showError: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: AppParams.Padding.extraLarge.scaled) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        DismissCircleButton()
                            .padding(.bottom, 15)
                        
                        Text("code_security".localize)
                            .font(.titleXLargeBold)
                        
                        Text(viewModel.descriptionText)
                            .multilineTextAlignment(.leading)
                            .font(.bodySmallRegular)
                            .foregroundStyle(Color.iLabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, AppParams.Padding.large)
                    
                    OTPField(
                        text: $viewModel.otpValue,
                        numberOfFields: viewModel.otpCount,
                        isFocused: _otpFieldFocus
                    )
                    
                    Text("send_code_after".localize(arguments: "00:\(String(format: "%02d", secondsRemaining))"))
                        .font(.caption)
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                            if secondsRemaining > 0 {
                                secondsRemaining -= 1
                            }
                        }
                        .foregroundStyle(Color.iLabel)
                        .font(.bodySmallRegular)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    SubmitButtonFactory.primary(title: "next".localize) {
                        self.viewModel.onClickValidate()
                    }
                    .set(isEnabled: viewModel.isValid)
                    .set(isLoading: viewModel.isLoading)
                    .disabled(viewModel.isLoading)
                }
            }
            .padding([.horizontal, .bottom], 20)
            
           
        }
        .onChange(of: otpFieldFocus, perform: { value in
            if !value {
                self.otpFieldFocus = true
            }
        })
        .onAppear {
            self.code =  Array(repeating: "", count: viewModel.otpCount)
            self.otpFieldFocus = true
            self.viewModel.onAppear()
            
            #if DEBUG
            viewModel.otpValue = "23"
            #endif
        }
        .navigationBarHidden(true)
    }
    
    private func showErrorAlert() {
        self.showError = true
    }
}

#Preview {
    NavigationStack {
        SecurityCodeInputView(viewModel: OTPViewModel(otpCount: 6))
    }
}
