//
//  FillProfileView.swift
//  Ildam
//
//  Created by applebro on 23/11/23.
//

import Foundation
import SwiftUI
import Core
import YallaUtils
import Combine

struct RegisterProfileView: View {
    @StateObject private var viewModel = RegisterProfileViewModel()
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate: Date = Date()
    @State private var birthDateValue: String = ""
    @State private var gender: Gender = .male
    @State private var showDatePicker: Bool = false
    
    @State
    private var pickerSize: CGRect = .zero
    
    @State
    private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .iPrimaryLite.opacity(1), location: 0),
                .init(color: .iPrimaryDark.opacity(1), location: 1),
            ], center: .top, startRadius: 0, endRadius: 300)
            .ignoresSafeArea()
            
            innerBody
        }
        .appSheet(isPresented: $showDatePicker) {
            datePickerView
        }
        .onChange(of: birthDate) { newValue in
            birthDateValue = newValue.toExtendedString(format: "dd.MM.yyyy", timezone: .current)
        }
    }
    
    private var innerBody: some View {
        VStack(alignment: .leading) {
            
            BackCircleButton()
                .colorScheme(.dark)
                .padding(.leading, AppParams.Padding.large)

            titleView
                .foregroundStyle(Color.white)
                .padding(AppParams.Padding.large)
            
            RoundedRectangle(cornerRadius: AppParams.Radius.large)
                .foregroundStyle(Color.background)
                .ignoresSafeArea()
                .overlay {
                    bottomSheet
                        .padding(.top, AppParams.Padding.extraLarge)
                }
        }
        .padding(.top, AppParams.Padding.large)
    }
    
    private func onClickBirthday() {
        withAnimation(.smooth.speed(1.5)) {
            self.showDatePicker = true
        }
    }
    
    private var titleView: some View {
        VStack(spacing: 0) {
            Text("welcome".localize)
                .font(.titleXLargeBold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("login.title.caption".localize)
                .font(.bodySmallRegular)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var bottomSheet: some View {
        VStack {
            VStack(spacing: 16.scaled) {
                YRoundedTextField {
                    YTextField(text: $firstName, placeholder: "insert.first_name".localize) // Имя
                        .padding(.horizontal, AppParams.Padding.default)
                }
                .set(borderColor: firstName.isEmpty ? .iBorderDisabled : .secondary)
                
                YRoundedTextField {
                    YTextField(text: $lastName, placeholder: "insert.last_name".localize) // Фамилия
                        .padding(.horizontal, AppParams.Padding.default)
                }
                .set(borderColor: lastName.isEmpty ? .iBorderDisabled : .secondary)
                
                YRoundedTextField {
                    HStack {
                        YTextField(text: $birthDateValue, placeholder: "birth_date".localize) // День рождения
                            .disabled(true)
                            .padding(.horizontal, AppParams.Padding.default)
                        
                        Spacer()
                        
                        Image("icon_calendar")
                            .padding(.horizontal)
                            .foregroundStyle(Color.label)
                    }
                    .background(Color.background.opacity(0.05))
                    .onTapGesture {
                        UIApplication.shared.dismissKeyboard()
                        onClickBirthday()
                    }
                }
                .set(borderColor: birthDateValue.isEmpty ? .iBorderDisabled : .secondary)
                .onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                    onClickBirthday()
                }
            }
            .padding(.horizontal, AppParams.Padding.large)
         
            HStack {
                pillButton(text: "male".localize, isSelected: gender == .male) {
                    gender = .male
                    
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                
                
                pillButton(text: "female".localize, isSelected: gender == .female) {
                    gender = .female
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
            .padding(.vertical, 16)
            .padding(.horizontal)

            Spacer()
            
            SubmitButtonFactory.primary(title: "next".localize) {
                viewModel.register(fn: firstName, ln: lastName, birthDate: birthDateValue, gender: gender)
            }
            .disabled(firstName == "" ? true : false)
            .padding(.horizontal)
        }
    }

    func pillButton(text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        RadioButton(title: text, isSelected: isSelected, checkmarkColor: .iPrimary, action: action)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.iBackgroundSecondary)
            .cornerRadius(18)
    }
    

    private var datePickerView: some View {
        DatePicker(
            selection: $birthDate,
            in: ...Date(),
            displayedComponents: .date,
            label: { EmptyView() }
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
   }
}

#Preview(body: {
    RegisterProfileView()
})

 
