//
//  ConfirmationSheet.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 04/11/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core

struct ConfirmationSheet: View {
    var imageName: String?
    var title: String
    var bodyText: String
    var buttonTitle: String
    var tapped: () -> Void
    
    var body: some View {
        VStack {
            if let imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250.scaled, height: 250.scaled)
            }
            
            VStack(alignment: .center, spacing: 12.scaled) {
                Text(title) // Вы действительно хотите удалить свой аккаунт?
                    .font(.titleBaseBold)
                    .multilineTextAlignment(.center)
                
                Text(bodyText)
                    .font(.bodyBaseMedium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.iLabelSubtle)
            }
            .padding(.top, AppParams.Padding.default)
            .padding(.horizontal, 32.scaled)
            SubmitButtonFactory.primary(
                title: buttonTitle
            ) {
                tapped()
            }
            .padding(.top, 48.scaled)
            .padding(.horizontal, AppParams.Padding.default)
        }
    }
}

extension View {
    func confirmationSheet(
        isPresented: Binding<Bool>,
        sheetTitle: String = "",
        imageName: String? = nil,
        title: String,
        bodyText: String,
        buttonTitle: String,
        tapped: @escaping () -> Void
    ) -> some View {
        appSheet(isPresented: isPresented, title: sheetTitle, sheetContent: {
            ConfirmationSheet(
                imageName: imageName,
                title: title,
                bodyText: bodyText,
                buttonTitle: buttonTitle,
                tapped: tapped
            )
        })
    }
    
    func deleteConfirmationSheet(
        isPresented: Binding<Bool>,
        sheetTitle: String = "",
        title: String,
        bodyText: String,
        buttonTitle: String,
        tapped: @escaping () -> Void
    ) -> some View {
        appSheet(isPresented: isPresented, title: sheetTitle, sheetContent: {
            ConfirmationSheet(
                imageName: "icon_trash_bin",
                title: title,
                bodyText: bodyText,
                buttonTitle: buttonTitle,
                tapped: tapped
            )
        })
    }
}

#Preview {
    ConfirmationSheet(
        title: "Вы действительно хотите удалить эту поездку?",
        bodyText: "После удаления поездки, восстановить все данные будет невозможно",
        buttonTitle: "delete".localize,
        tapped: {
            
        }
    )
}
