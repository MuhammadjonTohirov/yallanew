//
//  EditProfileInteractor.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 30/10/25.
//

import Foundation
import YallaKit
import UIKit

protocol EditProfileInteractorProtocol: Sendable {
    func userInfo() async throws -> UserInfo?
    func updateProfile(image: UIImage, name: String, surName: String?, gender: Gender?, birthDate: String?) async throws -> Bool
    func updateProfile(imageUrl: String, name: String, surName: String?, gender: Gender?, birthDate: String?) async throws -> Bool
}

struct EditProfileInteractor: EditProfileInteractorProtocol {
    func userInfo() async throws -> UserInfo? {
        await AuthService.shared.getUserInfo()?.userInfo
    }
    
    func updateProfile(image: UIImage, name: String, surName: String? = nil, gender: Gender? = nil, birthDate: String? = nil) async throws -> Bool {
        guard var imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Couldn't convert image to data")
            throw NetworkError.custom(message: "img.conversion.error".localize, code: 0)
        }
            
        if imageData.count >= 4 * 1024 * 1024 {
            if let compressedData = imageCompressor(maxFileSize: 4 * 1024 * 1024, image) {
                imageData = compressedData
            }
        }

        let result = await AuthService.shared.changeAvatar(profileAvatar: imageData)

        if let imageUrl = result.result?.image {
            return try await self.updateProfile(
                imageUrl: imageUrl,
                name: name,
                surName: surName,
                gender: gender ?? Gender.none,
                birthDate: birthDate
            )
        }
        
        return false
    }
    
    func updateProfile(imageUrl: String, name: String, surName: String? = nil, gender: Gender? = nil, birthDate: String? = nil) async throws -> Bool {
        let success = try await AuthService.shared.updateProfile(
            request: ProfileUpdateRequest(
                givenNames: name,
                surname: surName,
                birthday: birthDate,
                gender: gender ?? Gender.none,
                image: imageUrl
            )
        )

        return success
    }
}

extension EditProfileInteractor {
    private func imageCompressor(maxFileSize: Int64, _ image: UIImage) -> Data? {
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
            print("Unable to compress image to \(maxFileSize / 1000) kbytes or less.")
            return nil
        }
        return imageData
    }

}
