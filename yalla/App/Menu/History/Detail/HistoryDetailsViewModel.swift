//
//  HistoryDetailsViewModel.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 03/11/25.
//

import Foundation
import CoreLocation
import SwiftUI
import YallaKit
import Combine

class HistoryDetailsViewModel: ObservableObject {
    var orderId: Int?
    
    private var appConfigUseCase: AppConfigUseCase = AppConfigUseCaseImpl()
    
    private var hasPhone: Bool {
        appConfigUseCase.appConfig?.hasPhone ?? false
    }
    
    var phoneNumber: String {
        guard hasPhone else {
            return ""
        }
        return appConfigUseCase.appConfig?.setting?.supportPhone ?? ""
    }
    @Published var item: OrderDetails?
    @Published var isLoading: Bool = true
    @Published var isMapVisible: Bool = false
    
    @MainActor
    func onAppear() {
        if let orderId {
            Task {
                await self.loadOrderInfo(orderId: orderId)
            }
        }
    }
    
    
    private func loadOrderInfo(orderId: Int) async {
        self.showLoader()
        do {
            let info = try await OrderNetworkService.shared.archivedOrder(withId: orderId)
            await MainActor.run { self.item = info }
        } catch {
            
        }
        
        self.hideLoader()
        
        try? await Task.sleep(for: .milliseconds(700))
        Task {@MainActor in
            self.isMapVisible = true
            self.isLoading = false
        }
    }
    
    
    @MainActor
    private func set(orderInfo: OrderDetails?) {
        self.item = orderInfo
    }
    
    @MainActor
    private func showLoader() {
        self.isLoading = true
    }
    
    @MainActor
    private func hideLoader() {
        self.isLoading = false
    }
}

extension OrderDetails {
    var dateValue: Date? {
        guard let time = self.dateTime else {
            return nil
        }
        
        return .init(timeIntervalSince1970: time)
    }
}
