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
    @StateObject var viewModel: EditProfileViewModel
    
    @EnvironmentObject var navigator: Navigator
    
    @State
    private var pickerSize: CGRect = .zero
    
    @State
    private var showCamera = false
    
    @State
    private var showPhotoLibrary = false
    
    @State
    private var showDeletePhotoAlert = false
    
    init(viewModel: EditProfileViewModel = .init(interactor: EditProfileInteractor())) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            innerBody
                .padding(.bottom, AppParams.Padding.extraLarge)
            VStack {
                Spacer()
                SubmitButtonFactory.primary(title: "save".localize) {
                    viewModel.save()
                }
                .set(isEnabled: viewModel.isFormValid())
                .set(isLoading: viewModel.isLoading)
                .padding()
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Circle()
                    .frame(width: 38.scaled)
                    .foregroundStyle(Color.iBackgroundSecondary)
                    .opacity(isIOS26 ? 0 : 1)
                    .overlay {
                        Image.icon("icon_more_rounded").onClick {
                            viewModel.onClickShowMenu()
                        }
                    }
            }
        })
        .navigationTitle("edit.profile".localize)
        
        .appSheet(
            isPresented: .init(
                get: {
                    viewModel.sheetRoute != nil
                },
                set: { shown in
                    if !shown {
                        viewModel.sheetRoute = nil
                    }
                }
            ),
            title: viewModel.sheetRoute?.title ?? "", sheetContent: {
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
            }
        )
        .sheet(isPresented: $showCamera) {
            CameraView(selectedImage: $viewModel.selectedImage) { image in
                viewModel.sheetRoute = nil
                viewModel.changePhoto(image)
            }
        }
        .sheet(isPresented: $showPhotoLibrary) {
            PhotoLibraryView(selectedImage: $viewModel.selectedImage) { image in
                viewModel.sheetRoute = nil
                viewModel.changePhoto(image)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "")
        }
        .onAppear {
            viewModel.setNavigator(navigator)
        }
        .alert("want.delete.photo".localize, isPresented: $showDeletePhotoAlert) {
            Button("delete.photo".localize, role: .destructive) {
                viewModel.deletePhoto()
            }
            Button("cancel".localize, role: .cancel) {}
        }
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
                        KFImage(viewModel.userInfo?.imageURL)
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
                        YTextField(
                            text: .init(get: {
                                viewModel.birthDateValue ?? ""
                            }, set: { val in
                                viewModel.birthDateValue = val
                            }),
                            placeholder: "birth_date".localize
                        ) // День рождения
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
                .set(borderColor: (viewModel.birthDateValue ?? "").isEmpty ? .iBorderDisabled : .secondary)
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
        .padding(.top, 12)
        .scrollable()
        .scrollDismissesKeyboard(.interactively)
        .padding(.horizontal, AppParams.Padding.default)
        .onAppear {
            Task { @MainActor in
                await viewModel.onAppear()
            }
        }
    }
    
    func pillButton(text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        RadioButton(title: text, isSelected: isSelected, checkmarkColor: .iPrimary, action: action)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.iBackgroundSecondary)
            .cornerRadius(18)
    }
    
    @MainActor
    private func closeProfile() {
        
    }
    
    private var datePickerView: some View {
        DatePicker(
            selection: .init(get: {
                viewModel.birthDate ?? Date()
            }, set: { date in
                viewModel.birthDate = date
            }),
            in: Date().before(years: 100)...Date(),
            displayedComponents: .date,
            label: { EmptyView().frame(width: 0) }
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
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
            
            rowItemView(image: Image.icon("icon_dark_trash"), text: "delete.photo".localize)
                .onTapGesture {
                    viewModel.sheetRoute = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showDeletePhotoAlert = true
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
        ConfirmationSheet(
            imageName: "img_delete_user",
            title: "want.delete.account".localize,
            bodyText: "want.delete.account.descr".localize,
            buttonTitle: "delete.account".localize,
            tapped: {
                
            }
        )
    }
    
    private var logoutAccountSheetView: some View {
        ConfirmationSheet(
            imageName: "img_delete_user",
            title: "want.logout".localize,
            bodyText: "want.logout.descr".localize,
            buttonTitle: "logout".localize,
            tapped: {
                
            }
        )
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
            .environmentObject(Navigator())
    }
}
