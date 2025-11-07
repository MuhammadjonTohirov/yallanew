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
import NetworkLayer
import YallaUtils
import SwiftMessages

enum EditProfileSheetRoute: String, Identifiable, Hashable, Equatable {
    var id: String {
        self.rawValue
    }
    
    case menu
    case deleteAccount
    case logout
    case changePhoto
    case deletePhoto
    case datePicker
    
    var title: String {
        switch self {
        case .deleteAccount:
            return "delete.account".localize
        case .logout:
            return "logout".localize
        case .changePhoto:
            return "change.photo".localize
        case .deletePhoto:
            return "delete.photo".localize
            
        default:
            return ""
        }
    }
}

actor EditProfileViewModel: ObservableObject {
    
    @MainActor
    var navigator: Navigator?
    
    @MainActor
    @Published var firstName: String = ""
    
    @MainActor
    @Published var lastName: String = ""
    
    @MainActor
    @Published var birthDate: Date?
    
    @MainActor
    @Published var birthDateValue: String?
    
    @MainActor
    @Published var isSaveEnabled: Bool = false

    @MainActor
    @Published var selectedImage: UIImage? = nil
    
    @MainActor
    @Published var gender: Gender?
    
    @MainActor
    @Published var isLoading: Bool = false
        
    @MainActor
    @Published var sheetRoute: EditProfileSheetRoute?
    
    @MainActor
    private(set) var userInfo: UserInfo?
    
    private var cancellables: Set<AnyCancellable> = []
    
    @MainActor
    private var didAppear: Bool = false
    
    var interactor: (any EditProfileInteractorProtocol)?
    
    init(interactor: any EditProfileInteractorProtocol) {
        self.interactor = interactor
    }
    
    @MainActor
    func onAppear() async {
        if didAppear { return }
        
        didAppear = true
        
        await setupBirthDateChange()
        await setupData()
        await setupSaveButtonObserver()
    }
    
    @MainActor
    func logout() {
        
    }
    
    @MainActor
    func setNavigator(_ navigator: Navigator?) {
        self.navigator = navigator
    }
    
    func setInteractor(_ interactor: (any EditProfileInteractorProtocol)?) {
        self.interactor = interactor
    }
    
    @MainActor
    func isFormValid() -> Bool {
        !firstName.isNilOrEmpty && isSaveEnabled
    }
    
    @MainActor
    func onUpdateSuccess() async {
        // TODO: Handle update success
        navigator?.pop()
        Snackbar.show(message: "profile.update.success".localize, theme: .success)
    }
    
    @MainActor
    func onUpdateFailure(error: String?) async {
        // TODO: Handle update failure
        Snackbar.show(message: error ?? "Ошибка обновления профиля", theme: .error)
    }
    
    @MainActor
    func save() {
        self.isLoading = true
        let img = selectedImage
        let fn = self.firstName
        let ln = self.lastName
        let gender = self.gender
        let bd = self.birthDateValue
        let imgUrl = userInfo?.imageURL?.lastPathComponent ?? ""
        
        Task.detached { [weak self] in
            guard let self else { return }
            do {
                var result: Bool = false
                if let img {
                    result = try await self.interactor?.updateProfile(image: img, name: fn, surName: ln, gender: gender, birthDate: bd) ?? false
                } else {
                    result = try await self.interactor?.updateProfile(imageUrl: imgUrl, name: fn, surName: ln, gender: gender, birthDate: bd) ?? false
                }
                
                if !result {
                    await onUpdateFailure(error: "Failed to update profile")
                } else {
                    await onUpdateSuccess()
                }
                
            } catch {
                await onUpdateFailure(error: error.serverMessage)
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func setupData() {
        Task {
            await MainActor.run {
                self.isLoading = true
            }
            
            let info = try await self.interactor?.userInfo()
                        
            await MainActor.run {
                self.userInfo = info
                self.firstName = info?.givenNames ?? ""
                self.lastName = info?.surName ?? ""
                self.gender = Gender.init(rawValue: info?.gender ?? "")
                self.birthDateValue = info?.birthday ?? "" // dd.MM.yyyy
                self.birthDate = Date.from(string: info?.birthday ?? "", format: "dd.MM.yyyy")
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func setupBirthDateChange() {
        self.$birthDate.removeDuplicates().sink { [weak self] bdValue in
            guard let self else { return }
            
            Task { @MainActor in
                self.birthDateValue = bdValue?.toExtendedString(format: "dd.MM.yyyy")
            }
        }
        .store(in: &cancellables)
    }
    
    private func setupSaveButtonObserver() {
        Publishers.CombineLatest4($firstName, $lastName, $birthDateValue, $gender)
            .sink { [weak self] first, last, bd, gender in
                guard let self else { return }
                Task { @MainActor in
                    let original = self.userInfo
                    let initialFirst = original?.givenNames ?? ""
                    let initialLast = original?.surName ?? ""
                    let initialBirth = original?.birthday ?? ""
                    let initialGender = Gender(rawValue: original?.gender ?? "")

                    let currentBirth = bd ?? ""
                    let changed = (first != initialFirst) ||
                                  (last != initialLast) ||
                                  (currentBirth != initialBirth) ||
                                  (gender != initialGender)
                    self.isSaveEnabled = changed
                }
            }
            .store(in: &cancellables)
    }
}


extension EditProfileViewModel {
    @MainActor
    func changePhoto(_ image: UIImage) {
        isLoading = true
        selectedImage = image

        Task.detached { [weak self] in
            guard let self else { return }
            do {
                let ok = try await self.interactor?.updatePhoto(
                    image: image,
                    name: self.firstName,
                    surName: self.lastName,
                    gender: self.gender,
                    birthDate: self.birthDateValue
                ) ?? false
                await MainActor.run {
                    self.isLoading = false
                }
                if ok {
                    let info = try await self.interactor?.userInfo()
                    await MainActor.run {
                        self.userInfo = info
                    }
                }
            } catch {
                await self.onUpdateFailure(error: error.serverMessage)
                await MainActor.run { self.isLoading = false }
            }
        }
    }

    @MainActor
    func deletePhoto() {
        isLoading = true
        selectedImage = nil

        Task.detached { [weak self] in
            guard let self else { return }
            do {
                let ok = try await self.interactor?.removePhoto(
                    name: self.firstName,
                    surName: self.lastName,
                    gender: self.gender,
                    birthDate: self.birthDateValue
                ) ?? false
                await MainActor.run {
                    self.isLoading = false
                }
                if ok {
                    let info = try await self.interactor?.userInfo()
                    await MainActor.run {
                        self.userInfo = info
                    }
                }
            } catch {
                await self.onUpdateFailure(error: error.serverMessage)
                await MainActor.run { self.isLoading = false }
            }
        }
    }

    @MainActor
    func onClickBirthday() {
        UIApplication.shared.dismissKeyboard()
        
        self.setSheet(.datePicker)
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
