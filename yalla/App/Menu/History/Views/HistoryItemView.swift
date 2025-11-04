//
//  HistoryItemView.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 05/02/25.
//

import Foundation
import SwiftUI
import Core
import IldamSDK
import YallaUtils

struct HistoryListItemView: View {
    var item: OrderHistoryItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                fromView
                Spacer()
                Text((item.taxi?.totalPrice ?? 0).asMoneySum)
                    .font(.system(size: 16, weight: .bold))
            }
            
            HStack(alignment: .top) {
                toView
                Spacer()
               
            }
            
            footerView
                .padding(.leading, 4)
        }
        .padding(10)
        .background(content: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.iBackgroundSecondary)
        })
        .listRowSeparator(.hidden)
    }
    
    private var fromView: some View {
        HStack(alignment: .top) {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.clear)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 8)
                        .foregroundStyle(Color.iPrimary)
                }
            
            Text(item.taxi?.fromAddress ?? "-")
                .lineLimit(1)
                .font(.system(size: 14, weight: .bold))
                .frame(minHeight: 20)
        }
    }
    
    private var toView: some View {
        HStack(alignment: .top) {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.clear)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 8)
                        .foregroundStyle(Color.red)
                }
            
            Text(item.taxi?.toAddress ?? "-")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.iLabelSubtle)
                .frame(minHeight: 20)
            
            Spacer()
        }
    }
    
    private var footerView: some View {
        HStack(alignment: .bottom) {
            Text(item.time)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color.iLabelSubtle)
         
            Text(item.status.localize)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(item.statusObject.color)
            
            Spacer()
            
            Image("image_car")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 60, alignment: .center)
        }
    }
    
    func categotty(icon: String, name: String) -> any View {
        HStack {
            Image.icon(icon)
                .frame(width: 12, height: 12)
            
            Text(name)
                .foregroundColor(.iLabel)
                .font(.system(size: 16, weight: .medium))
        }
    }
}

extension OrderHistoryItem {
    var statusObject: OrderStatus {
        .init(rawValue: self.status) ?? .canceled
    }
}

extension OrderTaxiDetails {
    var fromAddress: String {
        self.routes.first?.fullAddress ?? ""
    }
    
    var toAddress: String {
        if self.routes.count > 1 {
            return self.routes.last?.fullAddress ?? ""
        }
        
        return "not.given".localize
    }
    
    var hasToAddress: Bool {
        self.routes.count > 1
    }
}

extension OrderStatus {
    var color: Color {
        switch self {
        case .new, .atAddress, .inFetters, .appointed, .sending:
            return .iPrimary
        case .canceled:
            return .red
        case .completed:
            return .iPrimary
        default:
            return .orange
        }
    }
}
