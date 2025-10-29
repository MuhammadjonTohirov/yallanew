//
//  SwitchView+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 28/10/25.
//

import Foundation
import YallaUtils
import SwiftUI

struct SwitchViewFactory {
    @ViewBuilder
    static func `default`(isOn: Binding<Bool>) -> some View {
        Group {
            if #available(iOS 26.0, *) {
                Toggle(isOn: isOn, label: {EmptyView()})
                    .tint(.iPrimary)
            } else {
                SwitchView(isOn: isOn, backgroundColor: .iPrimary, handleColor: .white)
            }
        }
    }
}

#Preview {
    SwitchViewFactory.default(isOn: .constant(false))
}
