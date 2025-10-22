//
//  TextFieldProtocol.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

public protocol TextFieldProtocol: View {
    var text: String {get set}
    var left: (() -> any View) {get}
    var right: (() -> any View) {get}
    
    func set(hintColor: Color) -> Self
    
    func set(font: Font) -> Self
    
    func set(format: String) -> Self
    
    func set(placeholderAlignment align: Alignment) -> Self
    
    func set(formatter: NumberFormatter) -> Self
    
    func keyboardType(_ type: UIKeyboardType) -> Self
    
    func set(height: CGFloat) -> Self
    
    func set(haveTitle: Bool) -> Self
}
