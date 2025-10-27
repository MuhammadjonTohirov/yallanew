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
    
    @State
    private var selectedLanguage: String = "uz"

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
           
            headerView
            languagesView
        }
        .frame(height: 180)
    }
    
    private var languagesView: some View {
        VStack(spacing: 18.scaled) {
            LanguageRowView(language: LanguageUz(), selected: .init(get: {
                selectedLanguage == LanguageUz().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageUz())
                }
            }))
            
            LanguageRowView(language: LanguageUzCryl(), selected: .init(get: {
                selectedLanguage == LanguageUzCryl().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageUzCryl())
                }
            }))
            
            LanguageRowView(language: LanguageRu(), selected: .init(get: {
                selectedLanguage == LanguageRu().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageRu())
                }
            }))
            
            LanguageRowView(language: LanguageEn(), selected: .init(get: {
                selectedLanguage == LanguageEn().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageEn())
                }
            }))
        }
    }
    
    private func selectLanguage(_ language: any LanguageProtocol) {
        UserSettings.shared.language = language.code
        
        selectedLanguage = language.code
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
