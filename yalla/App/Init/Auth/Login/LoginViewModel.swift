//
//  AuthViewModel.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import SwiftUI
import Core
import YallaKit
import Combine
import IldamSDK

enum AuthRoute: @MainActor ScreenRoute, Hashable {
    static func == (lhs: AuthRoute, rhs: AuthRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String {
        switch self {
        case .registerProfile:
            return "registerProfile"
        case .confirmOTP:
            return "confirmOTP"
        }
    }
    
    case registerProfile
    case confirmOTP(vm: OTPViewModel)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .registerProfile:
            EmptyView()
        case .confirmOTP(let vm):
            SecurityCodeInputView(viewModel: vm)
        }
    }
}

class LoginViewModel: ObservableObject {
    // Route used for non-OTP flows (e.g., register)
    var route: AuthRoute? {
        didSet {
            pushRoute = route != nil
        }
    }
    
    @Published var pushRoute = false
    
    // Controls OTP bottom sheet presentation
    @Published var presentOTP: Bool = false
    @Published var otpViewModelForSheet: OTPViewModel?
    @Published var shouldShowAlert: Bool = false
    @Published var isLoading: Bool = false
    
    var isValidForm: Bool {
        clearPhoneNumber.count == 12
    }
    /// username is phone number in our case
    @Published var phoneNumber: String = ""
    
    private var otpViewModel: OTPViewModel = .init()
    
    private var clearPhoneNumber: String {
        var _u = phoneNumber
        _u.removeAll(where: {$0 == "-"})
        _u.removeAll(where: {$0 == " "})
        return "998\(_u)"
    }
    
    private var otpCode: Int = -1
    
    func sendOTP() {
        guard !phoneNumber.isEmpty else {
            return
        }
        
        self.isLoading = true
        UserSettings.shared.username = clearPhoneNumber
        
        Task.detached(priority: .utility) { [weak self] in
            guard let self else {
                return
            }
            
            do {
                if let res = try await AuthService.shared.sendOTP(username: clearPhoneNumber) {
                    await self.onSuccessSendOTP(res)
                } else {
                    await self.onFailSendOTP()
                }
            } catch {
                debugPrint(error.serverMessage)
            }
        }
    }
    
    private func checkOTP(withCode code: String) async -> Bool {
        let result = await AuthService.shared.validate(
            username: clearPhoneNumber,
            code: code
        )
        
        let isSuccess = result != nil
        
        if isSuccess {
            onSuccessConfirmOTP(!result!.isClient)
        }
        return isSuccess
    }
    
    @MainActor
    private func onSuccessSendOTP(_ res: OTPResponse) {
        self.isLoading = false
        
        self.otpViewModel.onCheckOTP = { otp in
            return await self.checkOTP(withCode: otp)
        }
        // Present OTP as a bottom sheet instead of navigation push
        self.otpViewModelForSheet = self.otpViewModel
        self.presentOTP = true
    }
    
    private func onSuccessConfirmOTP(_ isNewClient: Bool) {
        DispatchQueue.main.async {
            // Dismiss OTP sheet before next navigation
            self.presentOTP = false
            
            if isNewClient {
                Logging.l(tag: "AuthViewModel", "Show register profile (new \(isNewClient))")
                self.showRegister()
            } else {
                self.showMain()
            }
        }
    }
    
    private func showMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            mainModel?.navigate(to: .home)
        }
    }
    
    private func showRegister() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.route = .registerProfile
        }
    }
    
    @MainActor
    private func onFailSendOTP() {
        self.isLoading = false
    }
}
