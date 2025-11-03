//
//  TravelHistorySection.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 01/04/25.
//

import Foundation
import SwiftUI
import IldamSDK

// MARK: - Section Model
struct TravelHistorySection: Identifiable {
    let id = UUID()
    let title: String
    var items: [OrderHistoryItem]
}

// MARK: - Navigation Routes
enum TravelHistoryRoute: @MainActor ScreenRoute {
    case showDetails(_ orderId: Int)
    
    var id: String {
        switch self {
        case .showDetails:
            return "showDetails"
        }
    }
    
    static func == (lhs: TravelHistoryRoute, rhs: TravelHistoryRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .showDetails(let orderId):
            HistoryDetailsView(orderId: orderId)
        }
    }
}
