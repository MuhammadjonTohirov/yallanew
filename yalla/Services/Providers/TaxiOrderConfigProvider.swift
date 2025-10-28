//
//  TaxiOrderConfigProvider.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 06/02/25.
//

import Foundation
import Core
import IldamSDK

protocol TaxiOrderConfigProviderDelegate: AnyObject {
    func didUpdateConfig(_ order: TaxiOrderConfig)
    func didClearConfig()
    func didUpdateRoute(_ route: [GRoutePoint])
    func didUpdateTariffs(_ tariffs: [TaxiTariff])
    func didUpdateTariffOptions(_ options: [Int])
    func didUpdateSelectedTariff(_ tariff: TaxiTariff?)
    func didUpdateFrom(_ from: GRoutePoint?)
}

extension TaxiOrderConfigProviderDelegate {
    func didUpdateConfig(_ order: TaxiOrderConfig){}
    func didClearConfig(){}
    func didUpdateRoute(_ route: [GRoutePoint]){}
    func didUpdateTariffs(_ tariffs: [TaxiTariff]){}
    func didUpdateTariffOptions(_ options: [Int]){}
    func didUpdateSelectedTariff(_ tariff: TaxiTariff?) {}
    func didUpdateFrom(_ from: GRoutePoint?) {}
}

protocol TaxiOrderConfigProviderProtocol {
    var config: TaxiOrderConfig { get }
    
    func set(config: TaxiOrderConfig)
    func set(from: GRoutePoint?)
    
    func clear()
    func addListener(_ listener: TaxiOrderConfigProviderDelegate)
    func removeListener(_ listener: TaxiOrderConfigProviderDelegate)
    
    func setRoute(list route: [GRoutePoint])
    func setTariff(list tariffs: [TaxiTariff])
    func setSelectedTariff(_ tariff: TaxiTariff?)
    func setTariff(options: [Int])

    /// nil if cash
    func setPayment(type: String?)
    
    func appendRoute(_ point: GRoutePoint)
    func appendRoute(address point: SelectAddressItem)
    func editRoute(at index: Int, with point: GRoutePoint)
    
    func clearRoute()
}

final class TaxiOrderConfigProvider: TaxiOrderConfigProviderProtocol {
    private(set) var config: TaxiOrderConfig = .init()
    
    static var shared: any TaxiOrderConfigProviderProtocol = TaxiOrderConfigProvider()
    
    private let listenersQueue = DispatchQueue(label: "TaxiConfigProvider.listeners", attributes: .concurrent)

    private var listeners = NSHashTable<AnyObject>.weakObjects()
    
    func set(config: TaxiOrderConfig) {
        self.config = config
        self.notifyDidUpdateConfig()
        
        Logging.l(tag: "TaxiOrderConfig", "set(config: ) \(config)")
    }
    
    func set(from: GRoutePoint?) {
        self.config.from = from
        self.notifyDidUpdateFromLocation()
    }
    
    func setTariff(list tariffs: [TaxiTariff]) {
        self.config.tariffs = tariffs
        self.notifyDidUpdateTariffs()
    }
    
    func setSelectedTariff(_ tariff: TaxiTariff?) {
        self.config.selectedTariff = tariff
        self.notifyDidUpdateSelectedTariff()
    }
    
    func setTariff(options: [Int]) {
        self.config.setOptions(options)
        self.notifyDidUpdateTariffOptions()
    }
    
    /// nil if cash
    func setPayment(type: String?) {
        if self.config.paymentTypeConfig == nil {
            self.config.paymentTypeConfig = .init(usingBonusAmount: 0, paymentType: "cash")
        }
        
        self.config.paymentTypeConfig?.paymentType = type ?? "cash"
    }
    
    func clear() {
        self.config.clearOptions()
        self.config.clearPaymentType()
        self.config.route = []
        self.notifyDidClearConfig()
    }
    
    func clearRoute() {
        self.config.route = []
        self.notifyDidUpdatRoute()
    }

    func addListener(_ listener: TaxiOrderConfigProviderDelegate) {
        listenersQueue.async(flags: .barrier) {
            if self.listeners.contains(listener) {
                return
            }

            debugPrint("TaxiOrderConfigProvider", "Listener", listener.self)
            self.listeners.add(listener)
        }
    }

    func removeListener(_ listener: TaxiOrderConfigProviderDelegate) {
        debugPrint("TaxiOrderConfigProvider", "Remove", listener.self)
        listenersQueue.async(flags: .barrier) {
            self.listeners.remove(listener)
        }
    }

    func notifyDidUpdateConfig() {

        listenersQueue.sync {
            for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
                listener.didUpdateConfig(config)
            }
        }
    }

    func notifyDidClearConfig() {
        listenersQueue.sync {
            for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
                listener.didClearConfig()
            }
        }
    }
    
    func notifyDidUpdatRoute() {
        listenersQueue.sync {
            for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
                listener.didUpdateRoute(config.route)
            }
        }
    }
    
    func notifyDidUpdateTariffs() {
        listenersQueue.sync {
            for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
                listener.didUpdateTariffs(config.tariffs)
            }
        }
    }
    
    func notifyDidUpdateTariffOptions() {
        listenersQueue.sync {
            for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
                listener.didUpdateTariffOptions(self.config.tariffConfig?.options ?? [])
            }
        }
    }
    
    func notifyDidUpdateSelectedTariff() {
        listenersQueue.sync {
            for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
                listener.didUpdateSelectedTariff(self.config.selectedTariff)
            }
        }
    }
    
    func notifyDidUpdateFromLocation() {
        listenersQueue.sync {
            for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
                listener.didUpdateFrom(self.config.from)
            }
        }
    }
}

extension TaxiOrderConfigProvider {
    func setRoute(list route: [GRoutePoint]) {
        self.config.route = route
        self.notifyDidUpdatRoute()
        self.notifyDidUpdateConfig()
    }
    
    func appendRoute(_ point: GRoutePoint) {
        self.config.route.append(point)
        self.notifyDidUpdatRoute()
        self.notifyDidUpdateConfig()
    }
    
    func appendRoute(address point: SelectAddressItem) {
        self.config.route.append(.init(id: point.id, order: self.config.route.count, location: point.coordinate, address: point.address))
        self.notifyDidUpdatRoute()
        self.notifyDidUpdateConfig()
    }
    
    func editRoute(at index: Int, with point: GRoutePoint) {
        self.config.route[index] = point
        self.notifyDidUpdatRoute()
        self.notifyDidUpdateConfig()
    }
}
