//
//  CarNumberView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 04/11/25.
//

import Foundation
import SwiftUI
import Core

struct CarNumberView: View {
    var number: String
    
    private var cityNumber: String {
        String(number.prefix(2))
    }
    
    private var remainingNumber: String {
        String(number.dropFirst(2))
    }
    
    var body: some View {
        Image("image_number_frame")
            .resizable()
            .frame(width: 110, height: 20)
            .overlay {
                HStack(spacing: 3) {
                    Text(cityNumber)
                        .padding(.leading, 5)
                    Text(remainingNumber.carNumberFormat)
                        .padding(.horizontal,8)
                    Spacer()
                }
                .foregroundStyle(Color.black)
                .font(.glNumbernschild(size: 20))
                .padding(.horizontal, 3)
        }
    }
}
