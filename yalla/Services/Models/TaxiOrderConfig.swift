//
//  OptionFilterModel.swift
//  Ildam
//
//  Created by applebro on 16/09/24.
//

import Foundation
import IldamSDK
import Core

struct TariffConfig {
    var options: [Int]
    var comment: String
    var date: Date?
    
    var isValid: Bool {
        return !options.isEmpty || !comment.isEmpty
    }
}

extension TariffConfig {
    var countString: String {
        if self.options.count == 0 {
            return ""
        }
        
        return self.options.count.description
    }
}

struct PaymentTypeConfig {
    var usingBonusAmount: Int
    var paymentType: String
}

final class TaxiOrderConfig: Sendable {
    var tariffConfig: TariffConfig?
    
    var tariffs: [TaxiTariff] = []
    var selectedTariff: TaxiTariff?
    
    var paymentTypeConfig: PaymentTypeConfig?
    
    var route: [GRoutePoint] = []
    var from: GRoutePoint?
    
    var allPoints: [GRoutePoint] {
        var allPoints: [GRoutePoint] = []
        if let from = from {
            allPoints.append(from)
        }
        allPoints.append(contentsOf: route)
        return allPoints
    }
    
    func clearOptions() {
        tariffConfig?.options = []
    }
    
    func clearPaymentType() {
        paymentTypeConfig = .init(usingBonusAmount: 0, paymentType: paymentTypeConfig?.paymentType ?? "cash")
    }
    
    func setOptions(_ options: [Int]) {
        if self.tariffConfig == nil {
            self.tariffConfig = TariffConfig(options: options, comment: "", date: nil)
        } else {
            self.tariffConfig?.options = options
        }
    }
    
    func setTariffs(_ tariffs: [TaxiTariff]) {
        self.tariffs = tariffs
    }
    
    func setSelectedTariff(_ selectedTariff: TaxiTariff?) {
        self.selectedTariff = selectedTariff
    }
    
    func setComment(_ comment: String) {
        if self.tariffConfig == nil {
            self.tariffConfig = TariffConfig(options: [], comment: comment, date: nil)
        } else {
            self.tariffConfig?.comment = comment
        }
    }
    
    func setDepartureDate(_ date: Date?) {
        if self.tariffConfig == nil {
            self.tariffConfig = TariffConfig(options: [], comment: "", date: date)
        } else {
            self.tariffConfig?.date = date
        }
    }
    
    func clearTariffConfig() {
        self.tariffConfig = nil
    }
}
