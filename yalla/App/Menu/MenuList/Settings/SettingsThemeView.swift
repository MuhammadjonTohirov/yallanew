//
//  SettingsThemeView.swift
//  Ildam
//
//  Created by applebro on 29/12/23.
//

import SwiftUI
import IldamSDK
import YallaUtils
import Core

struct SettingsThemeView: View {
    @State private var theme: AppTheme = UserSettings.shared.theme ?? .system {
        didSet {
            if UserSettings.shared.theme == theme {
                return
            }
            
            UserSettings.shared.theme = theme
            UserSettings.shared.set(interfaceStyle: theme.style)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            rowItem(icon: "icon_sun", title: AppTheme.system.name, isSelected: theme == .system)
                .onTapped(.background) {
                    theme = .system
                }
            
            rowItem(icon: "icon_moon", title: AppTheme.light.name, isSelected: theme == .light)
                .onTapped(.background) {
                    theme = .light
                }
            
            rowItem(icon: "icon_theme_setting", title: AppTheme.dark.name, isSelected: theme == .dark)
                .onTapped(.background) {
                    theme = .dark
                }
        }
        .padding(.horizontal)
        .onAppear {
            theme = UserSettings.shared.theme ?? .system
        }
    }
    
    var headerView: some View {
        ZStack {
            Text("app.theme".localize)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.label)
            HStack {
                
                DismissCircleButton()
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    func rowItem(icon: String, title: String, isSelected: Bool) -> some View {
       
            VStack(alignment: .leading, spacing: 0) {
               HStack (spacing: 10){
                   Image.icon(icon)
                       .frame(width: 24, height: 24)
                   
                    Text(title)
                        .font(.inter(.semibold, size: 16))
                        .foregroundStyle(Color.label)
                   
                   
                   Spacer()
                   
                   Circle()
                       .frame(width: 30, height: 30)
                       .foregroundStyle(isSelected ? Color.iPrimary : Color.background )
                       .overlay {
                           Image("icon_check")
                               .renderingMode(.template)
                               .foregroundStyle(.white)
                               .visibility(isSelected)
                    }
                }
            }

        .padding(.horizontal, 10)
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
}


#Preview {
    SettingsThemeView()
}

