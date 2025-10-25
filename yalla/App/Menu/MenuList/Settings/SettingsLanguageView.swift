//
//  SettingsLanguageView.swift
//  Ildam
//
//  Created by applebro on 29/12/23.
//

import SwiftUI
import IldamSDK
import YallaUtils
import Core

struct SettingsLanguageView: View {
    @State private var language: String = UserSettings.shared.language ?? Language.russian.code {
        didSet {
            UserSettings.shared.language = language
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
           
            headerView
            
            VStack(spacing: 18) {
                languageItem(
                    icon: "",
                    title: "O'zbekcha", detail: "", isSelected: language == Language.uzbek.code
                )
                .padding(.horizontal)
                .onTapped(.background, action: {
                    language = Language.uzbek.code
                    mainModel?.navigate(to: .loading)
                })

                languageItem(
                    icon: "",
                    title: "Русский",
                    detail: "", isSelected: language == Language.russian.code)
                    .padding(.horizontal)
                    .onTapped(.background, action: {
                        language = Language.russian.code
                        mainModel?.navigate(to: .loading)
                    })
            }

            Spacer()

        }
        .frame(height: 60)

    }
    
    func languageItem(icon: String ,title: String, detail: String, isSelected: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
               HStack {
                    Text(title)
                        .font(.inter(.semibold, size: 16))
                    
                    Text(detail)
                        .font(.inter(.regular, size: 12))
                        .foregroundStyle(Color.label)
                        .visibility(!detail.isEmpty)
                    
                    Spacer()
                    
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(isSelected ? Color.iPrimary : .init(uiColor: .systemGray4))
                        .overlay {
                            Image("icon_check")
                                .renderingMode(.template)
                                .foregroundStyle(.white)
                    }
                }
               .padding(.horizontal)
            }
        
        }
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isSelected ? Color.iBackgroundSecondary : Color.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(isSelected ? Color.iBackgroundSecondary : Color.iBorderDisabled, lineWidth: isSelected ? 0 : 2)
        )
        .animation(nil, value: UUID())
    }
    
    var headerView: some View {
        ZStack {
            Text("app.language".localize)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.label)
            HStack {
                DismissCircleButton()
                    .padding(.leading)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
}

#Preview {
    SettingsLanguageView()
}
