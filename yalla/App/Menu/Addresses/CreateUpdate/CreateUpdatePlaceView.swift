//
//  CreateUpdatePlaceView.swift
//  Ildam
//
//  Created by applebro on 17/12/23.
//

import Foundation
import SwiftUI
import CoreLocation
import YallaUtils
import Core
import IldamSDK

enum CRUDPlaceStrings {
    case wantToDelete
    case unableToDelete
    
    var msg: String {
        switch self {
        case .wantToDelete:
            "want_to_delete".localize
        case .unableToDelete:
            "delete_error".localize
        }
    }
}

struct CreateUpdatePlaceView: View {
    var addressItem: MyPlaceItem?
    
    var pageTitle: String {
        switch addressType {
        case .other:
            "new.address".localize
        case .home:
            "home".localize
        case .work:
            "work".localize
        }
    }
    
    var addressType: MyAddressType = .other
    
    private let errorMessage: CRUDPlaceStrings = .wantToDelete
    
    @StateObject private var vm: CreateUpdatePlaceViewModel = .init()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            fieldsView
                .padding(.top, 20.scaled)
            
            Spacer()
            
            SubmitButtonFactory.primary(title: vm.shouldCreate ? "create.address".localize : "update.address".localize) {
                vm.onSubmit { isOK in
                    dismiss.callAsFunction()
                }
            }
            .set(isEnabled: vm.isValidForm && !vm.isLoading)
            .set(isLoading: vm.isLoading)
            .disabled(vm.isLoading)
            .padding(.bottom, AppParams.Padding.default)
        }
//        .keyboardDismissable()
        .sheet(isPresented: $vm.showPickAddress, content: {
            SelectAddressView(viewModel: vm.addressPickerModel)
                .presentationDragIndicator(.visible)
        })
        .navigationTitle(pageTitle)
        .padding(.horizontal, AppParams.Padding.default)
        .onAppear {
            vm.set(addressItem: addressItem)
            vm.set(addressType: addressType)
            vm.onAppear()
            vm.shouldCreate = self.addressItem == nil
        }
    }
        
    private var fieldsView: some View {
        VStack(spacing: 10.scaled) {
            HStack {
                Circle()
                    .stroke(lineWidth: 5)
                    .frame(width: 14, height: 14, alignment: .center)
                    .foregroundStyle(.iPrimary)
                    .padding(.trailing, 10)
                
                Text(vm.address.isEmpty ? "paste.address".localize : vm.address)
                    .font(.bodyBaseMedium)
                    .foregroundStyle(
                        vm.address.isEmpty ? .iLabelSubtle : .iLabel
                    )
                
                Spacer()
            }
            .padding(.horizontal, AppParams.Padding.default)
            .overlay(RoundedRectangle(cornerRadius: 10.scaled).foregroundStyle(.iBackground.opacity(0.01)))
            .frame(height: 50.scaled)
            .background(
                RoundedRectangle(cornerRadius: 10.scaled)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.iBorderDisabled)
            )
            .onClick {
                self.vm.showMapAddressPicker()
            }

            YRoundedTextField {
                YTextField(text: $vm.name, placeholder: "title".localize) // Название
                    .frame(height: 50.scaled)
                    .padding(.horizontal, AppParams.Padding.medium)
            }
            .set(borderColor: .iBorderDisabled)

            HStack(spacing: 10.scaled) {
                YRoundedTextField {
                    YTextField(text: $vm.home, placeholder: "flat_or_house".localize) // Квартира
                        .frame(height: 50.scaled)
                        .padding(.horizontal, AppParams.Padding.default)
                }
                .set(borderColor: .iBorderDisabled)
                
                YRoundedTextField {
                    YTextField(text: $vm.entrance, placeholder: "entrance".localize) // Подьезд
                        .frame(height: 50.scaled)
                        .padding(.horizontal, AppParams.Padding.medium)
                }
                .set(borderColor: .iBorderDisabled)
            }
            
            YRoundedTextField {
                YTextField(text: $vm.comment, placeholder: "comment".localize) // Комментарий
                    .frame(height: 50.scaled)
                    .padding(.horizontal, AppParams.Padding.default)
            }
            .set(borderColor: .iBorderDisabled)
        }
    }
}


#Preview {
    CreateUpdatePlaceView()
}
