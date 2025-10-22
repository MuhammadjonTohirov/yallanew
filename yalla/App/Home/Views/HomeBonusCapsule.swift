//
//  HomeBonusCapsule.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 22/10/25.
//

import Foundation
import SwiftUI

struct HomeBonusCapsule: View {
    var body: some View {
        HStack(spacing: 3) {
            Image("icon_gold_coin")
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(verbatim: "30000")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(3)
        .padding(.trailing, 4)
        .background {
            Capsule()
                .foregroundStyle(
                    LinearGradient(colors: [.red, .iPrimaryDark], startPoint: .leading, endPoint: .trailing)
                )
        }
    }
}
