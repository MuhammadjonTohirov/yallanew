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

struct SettingsView: View {
    @State private var showLang: Bool = false
    @State private var showThem: Bool = false
    @State private var showDeleteAccount: Bool = false
    @State private var showAccountDeleted: Bool = false
    @State private var themeName: String = ""
    @State private var languageName: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                row(
                    icon: "icon_language-square",
                    title: "app.language".localize,
                    detail: languageName
                )
                .onTapped(.iBackgroundSecondary) {
                    self.showLang = true
                }
                .frame(height: 64.scaled)
                
                Divider()
                    .padding(.leading, 100.scaled)
                
                row(
                    icon: "icon_mask",
                    title: "app.theme".localize,
                    detail: themeName
                )
                .onTapped(.iBackgroundSecondary) {
                    self.showThem = true
                }
                .frame(height: 64.scaled)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16.scaled))
        .padding([.horizontal, .top], 20.scaled)
        .scrollable()
        .onAppear {
            themeName = UserSettings.shared.theme?.name ?? ""
            languageName = Language.language(UserSettings.shared.language ?? "ru").name
        }
        .appSheet(
            isPresented: $showLang,
            title: "app.language".localize
        ) {
            SettingsLanguageView()
        }
        .appSheet(
            isPresented: $showThem,
            title: "app.theme".localize
        ) {
            SettingsThemeView()
        }
        .navigationTitle("settings".localize)
        .navigationBarTitleDisplayMode(.large)
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
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.primary)
                
                if !detail.isEmpty {
                    Text(detail)
                        .font(.system(size: 13, weight: .regular))
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
