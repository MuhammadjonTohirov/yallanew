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
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.iPrimary)
                            .opacity(0.15)
                            .frame(width: 70, height: 70)
                        
                        Image(icon)
                        .resizable()
                        .frame(width: 24, height: 24)

                    }
    
                    // Title
                    Text(title.localize)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                
                Spacer()
    
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
            )
        }
    }
}
