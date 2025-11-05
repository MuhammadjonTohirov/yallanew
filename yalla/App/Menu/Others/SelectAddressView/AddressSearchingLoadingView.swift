//
//  AddressSearchingLoadingView.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 24/04/25.
//

import Foundation
import SwiftUI
import YallaUtils

struct AddressSearchingLoadingView: View {
    var isLoading: Bool = false
    
    var body: some View {
        loadingView
    }
    
    private var loadingView: some View {
        VStack(alignment: .leading, spacing: 0) {
            rowItem
                .redacted(reason: .placeholder)
            rowItem
                .redacted(reason: .placeholder)
            rowItem
                .redacted(reason: .placeholder)
        }
        .padding(.horizontal, 20)
        .horizontal(alignment: .leading)
    }
    
    private var rowItem: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 21)
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 161, height: 16)
            }
        }
        .foregroundStyle(Color.iLabel.opacity(0.2))
        .frame(height: 60)
    }
}
