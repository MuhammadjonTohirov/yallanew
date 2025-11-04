//
//  DeleteConfirmationView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 04/11/25.
//


import SwiftUI
import YallaUtils
import Core

struct DeleteConfirmationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 12) {
            Image("icon_trash_bin")
                .resizable()
                .frame(width: 250, height: 250)
                .aspectRatio(contentMode: .fill)
            // Title text
            Text("trip.delete.confirmation.title".localize)
                .font(.titleBaseBold)
                .multilineTextAlignment(.center)
                .foregroundColor(.iLabel)
 
            // Subtitle text
            Text("trip.delete.warning".localize)
                .font(.bodyBaseMedium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.iLabelSubtle)
 
            SubmitButton(backgroundColor: Color.iPrimary) {
                Text("order.delete.confirm".localize)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            action: {
                dismiss()
            }
            .padding(.top, 65.scaled)
            .padding(.horizontal, 16)
        }
        .padding(.top, 24.scaled)
    }
}

#Preview {
    Text("Body")
        .appSheet(isPresented: .constant(true), title: "Title", sheetContent: {
            DeleteConfirmationView()
        })
}
