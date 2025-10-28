//
//  ContactOptionCard.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 24/10/25.
//

import SwiftUI
import YallaUtils
import Core

struct ContactOptionCard: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon container
                VStack(alignment: .leading, spacing: 10) {
                    
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.iPrimary)
                            .opacity(0.15)
                            .frame(width: 44, height: 44)
                        
                        Image(icon)
                        .resizable()
                        .frame(width: 24, height: 24)

                    }
    
                    // Title
                    Text(title.localize)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                }
                
                Spacer()
    
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.iBackgroundSecondary)
            )
        }
    }
}

#Preview {
    ContactOptionCard(icon: "icon_telegramm", title: "asdsad") {
        
    }
}
