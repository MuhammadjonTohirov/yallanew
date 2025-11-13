//
//  SettingsView.swift
//  Ildam
//
//  Created by applebro on 10/12/23.
//

import SwiftUI
import IldamSDK
import YallaUtils
import Core
import Combine

struct SettingsView: View {
    @StateObject
    var viewModel: SettingsViewModel = .init()
    
    var body: some View {
        innerBody
    }
    
    var innerBody: some View {
        ZStack {
            VStack(spacing: 0) {
                row(
                    icon: "icon_language-square",
                    title: "app.language".localize,
                    detail: viewModel.selectedLanguage
                )
                .frame(height: 64.scaled)
                .onTapped(.iBackgroundSecondary, action: viewModel.onClickLanguage)

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.iBackgroundSecondary)
                    .overlay {
                        Divider()
                            .padding(.leading, 42.scaled)
                    }

                row(
                    icon: "icon_mask",
                    title: "app.theme".localize,
                    detail: viewModel.theme.name
                )
                .frame(height: 64.scaled)
                .onTapped(.iBackgroundSecondary, action: viewModel.onClickTheme)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16.scaled))
        .padding([.horizontal, .top], 20.scaled)
        .scrollable()
        .appSheet(
            isPresented: $viewModel.showLanguage,
            title: "app.language".localize
        ) {
            SettingsLanguageView(viewModel: viewModel)
        }
        .appSheet(
            isPresented: $viewModel.showTheme,
            title: "app.theme".localize
        ) {
            SettingsThemeView(viewModel: viewModel)
        }
        .navigationTitle("settings".localize)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    func row(icon: String, title: String, detail: String = "") -> some View {
        HStack(spacing: 12) {
            // Icon
            Image.icon(icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.primary)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title.localize)
                    .font(.bodyLargeMedium)
                    .foregroundStyle(Color.primary)
                
                if !detail.isEmpty {
                    Text(detail)
                        .font(.bodyCaptionMedium)
                        .foregroundStyle(Color.iLabel)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.iLabel)
                .frame(width: 24.scaled)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
