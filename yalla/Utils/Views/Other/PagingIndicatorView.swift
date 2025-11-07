//
//  PagingIndicatorView.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 07/11/25.
//

import Foundation
import SwiftUI

struct PagingIndicatorView: View {
    var pageCount: Int
    var currentPage: Int
    
    var body: some View {
        HStack {
            ForEach(0..<self.pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.iPrimary : Color.iBackgroundTertiary)
                    .frame(width: index == currentPage ? 24 : 10, height: 10)
            }
        }
    }
}
