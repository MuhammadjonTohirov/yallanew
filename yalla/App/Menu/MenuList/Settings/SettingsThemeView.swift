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
    @ObservedObject var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            rowItem(icon: "icon_sun", title: AppTheme.light.name, isSelected: viewModel.theme == .light) {
                viewModel.setSelectTheme(.light)
            }
            
            rowItem(icon: "icon_moon", title: AppTheme.dark.name, isSelected: viewModel.theme == .dark) {
                viewModel.setSelectTheme(.dark)
            }
            
            rowItem(icon: "icon_theme_setting", title: AppTheme.system.name, isSelected: viewModel.theme == .system) {
                viewModel.setSelectTheme(.system)
            }
        }
        .padding(.horizontal)
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
    
    func rowItem(icon: String, title: String, isSelected: Bool, onClick: @escaping () -> Void) -> some View {
        SelectableButtonContainer(action: onClick, content: {
            HStack (spacing: 10){
                Image.icon(icon)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.bodySmallRegular)
                    .foregroundStyle(Color.label)
            }
        }, isSelected: .init(get: {isSelected}, set: { val in debugPrint(val)}))
    }
}


#Preview {
    SettingsThemeView(viewModel: .init())
}

