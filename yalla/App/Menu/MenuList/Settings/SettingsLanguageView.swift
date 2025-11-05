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
    @ObservedObject
    var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            languagesView
        }
        .padding(.horizontal)
    }
    
    private var languagesView: some View {
        VStack(spacing: 18.scaled) {
            LanguageRowView(language: LanguageUz(), selected: .init(get: {
                viewModel.selectedLanguage == LanguageUz().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageUz())
                }
            }))
            
//            LanguageRowView(language: LanguageUzCryl(), selected: .init(get: {
//                viewModel.selectedLanguage == LanguageUzCryl().code
//            }, set: { selected in
//                if selected {
//                    selectLanguage(LanguageUzCryl())
//                }
//            }))
            
            LanguageRowView(language: LanguageRu(), selected: .init(get: {
                viewModel.selectedLanguage == LanguageRu().code
            }, set: { selected in
                if selected {
                    selectLanguage(LanguageRu())
                }
            }))
            
//            LanguageRowView(language: LanguageEn(), selected: .init(get: {
//                viewModel.selectedLanguage == LanguageEn().code
//            }, set: { selected in
//                if selected {
//                    selectLanguage(LanguageEn())
//                }
//            }))
        }
    }
    
    private func selectLanguage(_ language: any LanguageProtocol) {
        viewModel.setSelectLanguage(language.code)
    }
}

#Preview {
    SettingsLanguageView(viewModel: .init())
}
