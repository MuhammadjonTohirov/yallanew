//
//  EditProfileView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 24/10/25.
//

import Foundation
import SwiftUI
import Kingfisher
import Core
import YallaUtils
import SwiftMessages

struct EditProfileView: View {
    @StateObject var viewModel: EditProfileViewModel = .init()
    @Environment(\.dismiss) var dismiss
    
    @State
    private var pickerSize: CGRect = .zero
    
    @State
    private var showCamera = false
    
    @State
    private var showPhotoLibrary = false
    
    var body: some View {
        ZStack {
            innerBody
                .padding(.top, 11.scaled)
            
            VStack {
                Spacer()
                SubmitButtonFactory.primary(title: "save".localize) {
                    Task {
                        await submit()
                    }
                }
                .set(isEnabled: viewModel.isFormValid())
                .padding()
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Circle()
                    .frame(width: 38.scaled)
                    .foregroundStyle(Color.iBackgroundSecondary)
                    .overlay {
                        Image.icon("icon_more_rounded").onClick {
                            viewModel.onClickShowMenu()
                        }
                    }
            }
        })
        .appSheet(isPresented: .init(get: {
            viewModel.sheetRoute != nil
        }, set: { shown in
            if !shown {
                viewModel.sheetRoute = nil
            }
        }), title: viewModel.sheetRoute?.title ?? "", sheetContent: {
            switch viewModel.sheetRoute {
            case .changePhoto:
                photoPickSheetView
            case .menu:
                menuView
            case .deleteAccount:
                deleteAccountSheetView
            case .logout:
                logoutAccountSheetView
            case .datePicker:
                datePickerView
            default:
                EmptyView()
            }
        })
        .onChange(of: viewModel.birthDate) { newValue in
            viewModel.birthDateValue = newValue.toExtendedString(format: "dd.MM.yyyy", timezone: .current)
        }
        .sheet(isPresented: $showCamera) {
            CameraView(selectedImage: $viewModel.selectedImage) { image in
                viewModel.selectedImage = image
                viewModel.sheetRoute = nil
            }
        }
        .sheet(isPresented: $showPhotoLibrary) {
            PhotoLibraryView(selectedImage: $viewModel.selectedImage) { image in
                viewModel.selectedImage = image
                viewModel.sheetRoute = nil
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var innerBody: some View {
        VStack(alignment: .center, spacing: 50.scaled) {
            VStack(spacing: 12.scaled) {
                Group {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120.scaled, height: 120.scaled)
                            .clipShape(Circle())
                        
                    } else {
                        KFImage(UserSettings.shared.userInfo?.imageURL)
                            .placeholder {
                                Circle()
                                    .foregroundStyle(.iBackgroundSecondary)
                                    .frame(width: 120.scaled, height: 120.scaled)
                                    .overlay {
                                        Image("icon_gallery_add")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 60.scaled, height: 60.scaled)
                                            .foregroundStyle(Color.iLabel)
                                    }
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120.scaled, height: 120.scaled)
                            .clipShape(Circle())
                    }
                }
                
                Text("change.photo".localize)
                    .onClick {
                        viewModel.onClickChangePhoto()
                    }
            }
            .font(.bodySmallMedium)
            
            VStack(spacing: 16.scaled) {
                YRoundedTextField {
                    YTextField(text: $viewModel.firstName, placeholder: "insert.first_name".localize) // Имя
                        .padding(.horizontal, AppParams.Padding.default)
                }
                .set(borderColor: viewModel.firstName.isEmpty ? .iBorderDisabled : .secondary)
                
                YRoundedTextField {
                    YTextField(text: $viewModel.lastName, placeholder: "insert.last_name".localize) // Фамилия
                        .padding(.horizontal, AppParams.Padding.default)
                }
                .set(borderColor: viewModel.lastName.isEmpty ? .iBorderDisabled : .secondary)
                
                YRoundedTextField {
                    HStack {
                        YTextField(text: $viewModel.birthDateValue, placeholder: "birth_date".localize) // День рождения
                            .disabled(true)
                            .padding(.horizontal, AppParams.Padding.default)
                        
                        Spacer()
                        
                        Image("icon_calendar")
                            .renderingMode(.template)
                            .padding(.horizontal)
                            .foregroundStyle(Color.label)
                    }
                    .background(Color.background.opacity(0.05))
                    .onTapGesture {
                        viewModel.onClickBirthday()
                    }
                }
                .set(borderColor: viewModel.birthDateValue.isEmpty ? .iBorderDisabled : .secondary)
                .onTapGesture {
                    viewModel.onClickBirthday()
                }
                
                HStack {
                    pillButton(text: "male".localize, isSelected: viewModel.gender == .male) {
                        viewModel.gender = .male
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    
                    pillButton(text: "female".localize, isSelected: viewModel.gender == .female) {
                        viewModel.gender = .female
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
            }
            
            Spacer()
        }
        .scrollable()
        .scrollDismissesKeyboard(.interactively)
        .padding(.horizontal, AppParams.Padding.default)
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    func pillButton(text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        RadioButton(title: text, isSelected: isSelected, checkmarkColor: .iPrimary, action: action)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.iBackgroundSecondary)
            .cornerRadius(18)
    }
    
    private func submit() async {
        if let image = viewModel.selectedImage {
            await viewModel.changeAvatar(image: image) {
                Task { @MainActor in
                    closeProfile()
                }
            }
        } else {
            await viewModel.updateProfile(
                name: viewModel.firstName.isEmpty ? nil : viewModel.firstName,
                surName: viewModel.lastName.isEmpty ? nil : viewModel.lastName,
                gender: viewModel.gender,
                birthDate: viewModel.birthDateValue.isEmpty ? nil : viewModel.birthDateValue,
                image: ""
            ) {
                Task { @MainActor in
                    closeProfile()
                }
            }
        }
    }
    
    @MainActor
    private func closeProfile() {
        
    }
    
    private var datePickerView: some View {
        DatePicker(
            selection: $viewModel.birthDate,
            in: ...Date(),
            displayedComponents: .date,
            label: { EmptyView() }
        )
        .datePickerStyle(.graphical)
    }
    private var photoPickSheetView: some View {
        VStack(alignment: .leading, spacing: 10.scaled) {
            rowItemView(image: Image.icon("icon_camera"), text: "capture.photo".localize)
                .onTapGesture {
                    viewModel.sheetRoute = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCamera = true
                    }
                }
            
            rowItemView(image: Image.icon("icon_gallery"), text: "select.from.gallery".localize)
                .onTapGesture {
                    viewModel.sheetRoute = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showPhotoLibrary = true
                    }
                }
        }
        .padding(.horizontal, 16.scaled)
    }
    
    private var menuView: some View {
        VStack(alignment: .leading, spacing: 10.scaled) {
            
            rowItemView(image: Image("icon_trash"), text: "delete.account".localize)

            .onClick {
                viewModel.onClickShowDeleteAccountSheet()
            }
            
            rowItemView(image: Image.icon("icon_logout"), text: "logout".localize)
            .onClick {
                viewModel.onClickLogoutAccount()
            }
        }
        .padding(.horizontal, 16.scaled)
    }
    
    private var deleteAccountSheetView: some View {
        VStack {
            Image("img_delete_user")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250.scaled, height: 250.scaled)
            
            VStack(alignment: .center, spacing: 12.scaled) {
                Text("want.delete.account".localize) // Вы действительно хотите удалить свой аккаунт?
                    .font(.titleBaseBold)
                    .multilineTextAlignment(.center)
                
                Text("want.delete.account.descr".localize) // После удаления аккаунта, восстановить все данные будут невозможны
                    .font(.bodyBaseMedium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.iLabelSubtle)
            }
            .padding(.top, AppParams.Padding.default)
            
            SubmitButtonFactory.primary(
                title: "delete.account".localize
            ) {
                
            }
            .padding(.top, 48.scaled)
            .padding(.horizontal, AppParams.Padding.default)
        }
    }
    
    private var logoutAccountSheetView: some View {
        VStack {
            Image("img_delete_user")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250.scaled, height: 250.scaled)
            
            VStack(alignment: .center, spacing: 12.scaled) {
                Text("want.logout".localize) // Вы действительно хотите удалить свой аккаунт?
                    .font(.titleBaseBold)
                    .multilineTextAlignment(.center)
                
                Text("want.logout.descr".localize) // После удаления аккаунта, восстановить все данные будут невозможны
                    .font(.bodyBaseMedium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.iLabelSubtle)
            }
            .padding(.top, AppParams.Padding.default)
            
            SubmitButtonFactory.primary(
                title: "logout".localize
            ) {
                
            }
            .padding(.top, 48.scaled)
            .padding(.horizontal, AppParams.Padding.default)
        }
    }
    
    private func rowItemView(image: some View, text: String) -> some View {
        HStack(spacing: 12.scaled) {
            image
            Text(text) // Удалить аккаунт
                .font(.bodyBaseMedium)
        }
        .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
        .frame(height: 60)
        .padding(.horizontal, 16.scaled)
        .background {
            RoundedRectangle(cornerRadius: 16.scaled).foregroundStyle(.iBackgroundSecondary)
        }
    }
}


#Preview {
    NavigationStack {
        EditProfileView()
    }
}
