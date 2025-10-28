
import AVFoundation
import SwiftMessages
import UIKit
import SwiftUI
import IldamSDK
import Core
import Combine
import NetworkLayer

class AddCardViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    @Published var showAlert: Bool = false
    @Published var showScanner: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertAction: (() -> Void)? = nil
    @Published var isLoading: Bool = false
    @Published var shouldDismiss: Bool = false
    @Published var shouldShowOTPView: Bool = false
    
    let otpModel = OTPViewModel(otpCount: 6)
    var key: String = ""

    func onClickScanCard() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraStatus {
        case .notDetermined:
            // Request permission for the first time
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showScanner = true
                    }
                }
            }
        case .authorized:
            // Permission already granted
            showScanner = true
        case .denied, .restricted:
            // Permission denied or restricted
            showSettingsAlert()
        @unknown default:
            break
        }
    }

    private func showSettingsAlert() {
        alertMessage = "camera.access.required".localize
        alertAction = {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        showAlert = true
    }
    
    func addCardService(cardNumber: String, expiry: String) {
        Task(priority: .utility) { [weak self] in
            guard let self else {
                return
            }
            await MainActor.run {
                self.isLoading = true
            }
            do {
                
                if let result = try await CardService.shared.addCard(
                    request: .init(
                        cardNumber: cardNumber.replacingOccurrences(of: " ", with: ""),    
                        expiry: expiry.replacingOccurrences(of: "/", with: "")
                    )
                ), let key = result.key {
                    await self.onSuccessSendOTP(key)
                } else {
                    await self.onFailSendOTP(message: nil)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
                await self.onFailSendOTP(message: error.serverMessage)
                debugPrint(error.serverMessage)
            }
        }
    }
    
    private func checkOTP(withCode code: String, key: String) async -> Bool {
        
        let result = try? await CardService.shared.verifyCard(request: .init(key: key, code: code))
        
        let isSuccess = result != nil
        
        if isSuccess {
            await onSuccesConfirmOTP(result ?? false)
        }
        
        return isSuccess
    }
    
    @MainActor
    private func onSuccessSendOTP(_ key: String) async {
        self.isLoading = false
        self.otpModel.onCheckOTP = { [weak self] otp in
            guard let self else { return false }
            return await self.checkOTP(withCode: otp, key: key)
        }
        self.shouldShowOTPView = true
    }

    @MainActor
    func onSuccesConfirmOTP(_ isCorrect: Bool) async {
        if isCorrect {
            self.shouldShowOTPView = false
            self.shouldDismiss = true
        }
    }
    
    @MainActor
    private func onFailSendOTP(message: String?) async {
        self.isLoading = false
        Snackbar.show(message: message ?? "ivalid.card.info".localize, theme: .error)
    }
}
