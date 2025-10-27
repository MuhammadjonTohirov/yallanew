//
//  EditProfileViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 24/10/25.
//

import Foundation
import Combine
import Core
import SwiftUI
import IldamSDK
import YallaUtils

enum EditProfileSheetRoute: String, Identifiable, Hashable, Equatable {
    var id: String {
        self.rawValue
    }
    
    case menu
    case deleteAccount
    case logout
    case changePhoto
    
    var title: String {
        switch self {
        case .deleteAccount:
            return "delete.account".localize
        case .logout:
            return "logout".localize
        default:
            return "change.photo".localize
        }
    }
}

actor EditProfileViewModel: ObservableObject {
    @MainActor
    @Published var firstName: String = ""
    
    @MainActor
    @Published var lastName: String = ""
    
    @MainActor
    @Published var birthDate: Date = Date()
    
    @MainActor
    @Published var birthDateValue: String = ""

    @MainActor
    @Published var selectedImage: UIImage? = nil
    
    @MainActor
    @Published var gender: Gender?
    
    @MainActor
    @Published var showDatePicker: Bool = false
    
    @MainActor
    @Published var isLoading: Bool = false
        
    @MainActor
    @Published var sheetRoute: EditProfileSheetRoute?
    
    @MainActor
    func onAppear() {
        
    }
    
    @MainActor
    func logout() {
        
    }
    
    @MainActor
    func isFormValid() -> Bool {
        false
    }
    
    func changeAvatar(image: UIImage, completion: @escaping @Sendable () -> Void) {
        guard var imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Couldn't convert image to data")
            completion()
            return
        }
            
        if imageData.count >= 1 * 1024 * 1024 {
            if let compressedData = imageCompressor(maxFileSize: 1 * 1024 * 1024, image) {
                imageData = compressedData
            } else {
                completion()
                return
            }
        }
        
        Task { @MainActor in
            self.isLoading = true
        }
        
        Task {
            let result = await AuthService.shared.changeAvatar(profileAvatar: imageData)

            let success = result.success
            
            if let imageUrl = result.result?.image {
                await self.updateProfile(
                    name: self.firstName,
                    surName: self.lastName,
                    gender: self.gender,
                    birthDate: self.birthDateValue,
                    image: imageUrl
                ) {
                    Task { @MainActor in
                        completion()
                    }
                }
            }
            
            if !success {
                Task { @MainActor in
                    self.onUpdateFailure(error: "image_size_error".localize)
                }
            } else {
                Task { @MainActor in
                    completion()
                }
            }
        }
    }
    
    func updateProfile(name: String? = nil, surName: String? = nil, gender: Gender? = nil, birthDate: String? = nil, image: String, completion: @escaping @Sendable () -> Void) async {
        await MainActor.run {
            self.isLoading = true
        }
        
        let success = await AuthService.shared.updateProfile(
            request: ProfileUpdateRequest(
                givenNames: name,
                surname: surName,
                birthday: birthDateValue,
                gender: gender,
                image: image
            )
        )

        Task { @MainActor in
            if success {
                onUpdateSuccess(completion: completion)
            } else {
                onUpdateFailure(error: nil)
            }
        }
    }
    
    func imageCompressor(maxFileSize: Int64, _ image: UIImage) -> Data? {
        var compression: CGFloat = 1.0
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            print("Failed to generate JPEG data from image.")
            return nil
        }
        
        while imageData.count > maxFileSize && compression > 0.01 {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                imageData = compressedData
            } else {
                print("Failed to compress image at quality \(compression).")
                return nil
            }
        }
        
        if imageData.count > maxFileSize {
            print("Unable to compress image to 2 MB.")
            return nil
        }
        return imageData
    }
    
    @MainActor
    func onUpdateSuccess(completion: @escaping () -> Void) {
//        Task {
//            await loadPreqrequisites()
//            await MainActor.run {
//                isLoading = false
//                
//                completion()
//            }
//        }
    }
    
    @MainActor
    func onUpdateFailure(error: String?) {
//        Task {
//            await MainActor.run {
//                isLoading = false
//                alertDarta = .init(
//                    title: "error".localize,
//                    message: "profile_update_fail".localize,
//                    actions: [
//                        CancelAlertButton(title: "ok".localize, action: {
//                            self.showAlert = false
//                        })
//                    ]
//                )
//                self.showAlert = true
//            }
//        }
    }
}

// MARK: Actions

extension EditProfileViewModel {
    @MainActor
    func onClickBirthday() {
        UIApplication.shared.dismissKeyboard()
        
        self.showDatePicker = true
    }
    
    @MainActor
    func onClickShowMenu() {
        UIApplication.shared.dismissKeyboard()
        
        setSheet(.menu)
    }
    
    @MainActor
    func onClickChangePhoto() {
        UIApplication.shared.dismissKeyboard()

        setSheet(.changePhoto)
    }
    
    @MainActor
    func onClickShowDeleteAccountSheet() {
        UIApplication.shared.dismissKeyboard()
        
        setSheet(.deleteAccount)
    }
    
    @MainActor
    func onClickLogoutAccount() {
        UIApplication.shared.dismissKeyboard()
        setSheet(.logout)
    }
    
    @MainActor
    func setSheet(_ route: EditProfileSheetRoute?) {
        var duration: TimeInterval = 0
        if sheetRoute != nil {
            self.sheetRoute = nil
            duration = 0.33
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.sheetRoute = route
        }
    }
}

extension Gender: @retroactive @unchecked Sendable {
    
}
