//
//  HomeHeaderView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 22/10/25.
//

import Foundation
import SwiftUI
import YallaUtils

struct HomeHeaderView: View {
    var onClickMenu: () -> Void = { }
    var body: some View {
        HStack {
            Button(action: {
                onClickMenu()
            }, label: {
                if isIOS26 {
                    Image("icon_hamburger")
                        .renderingMode(.template)
                        .foregroundStyle(.iLabel)
                        .frame(height: 32)
                } else {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.background)
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                        .overlay {
                            Image("icon_hamburger")
                                .renderingMode(.template)
                                .foregroundStyle(.iLabel)
                        }
                }
            })
            .glassyButtonSyle
            Spacer()
            
            HomeBonusCapsule()
        }
    }
}

#Preview {
    HomeHeaderView()
}
