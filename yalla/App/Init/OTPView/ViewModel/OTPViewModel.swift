//
//  OTPViewModel.swift
//  Ildam
//
//  Created by applebro on 09/12/23.
//

import Foundation
import Core
import YallaUtils
import Combine

class OTPViewModel: ObservableObject {
    @Published var shouldShowAlert: Bool = false
    @MainActor
    @Published var otpValue: String = "" {
        didSet {
            // Auto-submit when the OTP reaches required length
            if otpValue.count == otpCount && !isLoading {
                onClickValidate()
            }
        }
    }
    @MainActor
    @Published var isLoading: Bool = false
    
    var descriptionText: String {
        let lang = UserSettings.shared.language
        
        switch lang {
        case LanguageUz().code, LanguageUzCryl().code:
            return "enter_code_description".localize(
                arguments: UserSettings.shared.username ?? "", otpCount.description
            )
        default:
            return "enter_code_description".localize(
                arguments: otpCount.description, UserSettings.shared.username ?? ""
            )
        }
    }
    
    @MainActor
    var isValid: Bool {
        otpValue.count == otpCount
    }
    
    var onCheckOTP: ((String) async -> Bool)?
    
    var otpCount: Int
    
    init(otpCount: Int = 5) {
        self.otpCount = otpCount
    }
    
    @MainActor
    func onAppear() {
        self.otpValue = ""
    }
    
    private func checkOTP() async -> Bool {
        (await onCheckOTP?(otpValue)) ?? false
    }
    
    @MainActor
    func onClickValidate() {
        isLoading = true
        Task {
            if !(await checkOTP()) {
                showError(message: "invalid_otp".localize)
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    func showError(message: String) {
        
    }
}
