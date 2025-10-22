//
//  ScrollableModifier.swift
//  UnitedUIKit
//
//  Created by applebro on 23/10/23.
//

import Foundation
import SwiftUI

struct ScrollableModifier: ViewModifier {
    var axis: Axis.Set
    var indicators: Bool
    
    func body(content: Content) -> some View {
        ScrollView(axis, showsIndicators: indicators) {
            content
        }
    }
}
