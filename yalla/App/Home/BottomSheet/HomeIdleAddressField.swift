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

struct HomeIdleAddressField: View {
    var onWhereToGo: () -> Void = { }
    var onLetsGo: () -> Void = { }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Circle()
                    .frame(width: 14.scaled)
                    .foregroundStyle(.iPrimary)
                    .overlay {
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 6.21.scaled)
                    }
                    .padding(.leading, AppParams.Padding.default)
                
                Text("where.to.go".localize)
                    .foregroundStyle(.iLabel)
                    .font(.bodyBaseBold)

                Spacer()
            }
            .frame(height: 60.scaled)
            .frame(maxWidth: .infinity)
            .onTapped(.iBackgroundSecondary) {
                onWhereToGo()
            }

            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(.iLabel)
                .frame(width: 60.scaled, height: 60.scaled)
                .onTapped(.iBackgroundSecondary) {
                    onLetsGo()
                }

        }
        .background(Color.iBackgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16.scaled))
    }
}

#Preview {
    HomeIdleAddressField()
}
