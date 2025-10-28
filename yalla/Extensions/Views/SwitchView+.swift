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
    static func `default`(isOn: Binding<Bool>) -> SwitchView {
        SwitchView(isOn: isOn, backgroundColor: .iPrimary, handleColor: .white)
    }
}

#Preview {
    SwitchViewFactory.default(isOn: .constant(false)) 
}
