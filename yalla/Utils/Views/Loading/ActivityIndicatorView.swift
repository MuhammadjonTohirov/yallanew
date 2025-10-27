//
//  ActivityIndicatorView.swift
//  UnitedUIKit
//
//  Created by applebro on 08/10/23.
//

import Foundation
import SwiftUI

//UIActivityIndicator View

public struct ActivityIndicatorView: UIViewRepresentable {
    
    public init() {}
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .secondaryLabel
        indicator.startAnimating()
        return indicator
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}

#Preview {
    ActivityIndicatorView()
}

