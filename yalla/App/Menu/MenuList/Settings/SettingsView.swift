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
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                row(
                    icon: "icon_language-square",
                    title: "app.language".localize,
                    detail: Language.language(UserSettings.shared.language ?? "ru").name)
                .padding(.horizontal)
                .onTapped(.background) {
                    self.showLang = true
                }
                
                row(icon: "icon_mask",
                    title: "app.theme".localize,
                    detail: themeName)
                .padding(.horizontal )
                .onTapped(.background) {
                    self.showThem = true
                }
            }
            .frame(height: 60)
            
            Spacer()
        }
        .padding(.top,40)
        .onAppear {
            themeName = UserSettings.shared.theme?.name ?? ""
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
        
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(icon)
                        .renderingMode(.original)
                        .foregroundStyle(Color.background)
                        .frame(width: 24, height: 24)
                    
                    Text(title.localize)
                        .font(.inter(.bold, size: 16))
                        .foregroundStyle(Color.label)
                }
                
                if !detail.isEmpty {
                    Text(detail)
                        .font(.inter(.regular, size: 12))
                        .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                }
            }
            Spacer()
 
            Image(systemName: "chevron.right")
        }
        .frame(height: 60)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
