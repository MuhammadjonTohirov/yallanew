//
//  HomeHeaderView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 22/10/25.
//

import Foundation
import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 44, height: 44)
                .foregroundStyle(.background)
                .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                .overlay {
                    Image("icon_hamburger")
                        .renderingMode(.template)
                        .foregroundStyle(.iLabel)

                }
            
            Spacer()
            
            HomeBonusCapsule()
        }
    }
}
