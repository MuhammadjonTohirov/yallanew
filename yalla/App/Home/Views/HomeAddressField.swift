//
//  HomeAddressField.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 22/10/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

struct HomeAddressField: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16.scaled)
            .frame(height: 60.scaled)
            .foregroundStyle(Color.iBackgroundSecondary)
            .overlay {
                HStack {
                    Circle()
                        .frame(width: 14.scaled)
                        .foregroundStyle(.iPrimary)
                        .overlay {
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: 6.21.scaled)
                        }
                    
                    Text("where.to.go".localize)
                        .font(.bodyBaseBold)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                }
                .padding(.horizontal, AppParams.Padding.default)
            }
    }
}

#Preview {
    HomeAddressField()
}
