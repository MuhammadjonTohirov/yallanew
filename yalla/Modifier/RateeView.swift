//
//  RateeView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 10/11/25.
//

import SwiftUI

struct RateeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image("icon_active_star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 66, height: 66)

            Image("icon_noactive_star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 66, height: 66)
        }
    }
}

#Preview {
    RateeView()
}
