//
//  TaxiOrderConfigProvider.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 06/02/25.
//

import Foundation
import Core
import IldamSDK
import Combine

protocol TaxiOrderConfigProviderDelegate: AnyObject, Sendable {
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

actor TaxiOrderConfigChangeSubjects {
    var passthrough: PassthroughSubject<TaxiOrderConfig, Never> = .init()
}

protocol TaxiOrderConfigProviderProtocol: Sendable {
    var config: TaxiOrderConfig { get async }
    
    func set(config: TaxiOrderConfig) async
    func set(from: GRoutePoint?) async
    
    func clear() async
    func addListener(_ listener: TaxiOrderConfigProviderDelegate) async
    func removeListener(_ listener: TaxiOrderConfigProviderDelegate) async
    
    func setRoute(list route: [GRoutePoint]) async
    func setTariff(list tariffs: [TaxiTariff]) async
    func setSelectedTariff(_ tariff: TaxiTariff?) async
    func setTariff(options: [Int]) async

    /// nil if cash
    func setPayment(type: String?) async
    
    func appendRoute(_ point: GRoutePoint) async
    func appendRoute(address point: SelectAddressItem) async
    func editRoute(at index: Int, with point: GRoutePoint) async
    
    func clearRoute() async
}

actor TaxiOrderConfigProvider: TaxiOrderConfigProviderProtocol {
    private(set) var config: TaxiOrderConfig = .init()
    
    static var shared: any TaxiOrderConfigProviderProtocol = TaxiOrderConfigProvider()
    private(set) var changeSubjects: TaxiOrderConfigChangeSubjects = .init()
    
    private var listeners = NSHashTable<AnyObject>.weakObjects()
    
    func set(config: TaxiOrderConfig) async {
        self.config = config
        await self.notifyDidUpdateConfig()
        
        Logging.l(tag: "TaxiOrderConfig", "set(config: ) \(config)")
    }
    
    @MainActor
    func set(from: GRoutePoint?) async {
        await self.config.from = from
        await self.notifyDidUpdateFromLocation()
    }
    
    @MainActor
    func setTariff(list tariffs: [TaxiTariff]) async {
        await self.config.tariffs = tariffs
        await self.notifyDidUpdateTariffs()
    }
    
    @MainActor
    func setSelectedTariff(_ tariff: TaxiTariff?) async {
        await self.config.selectedTariff = tariff
        await self.notifyDidUpdateSelectedTariff()
    }
    
    @MainActor
    func setTariff(options: [Int]) async {
        await self.config.setOptions(options)
        await self.notifyDidUpdateTariffOptions()
    }
    
    /// nil if cash
    @MainActor
    func setPayment(type: String?) async {
        if await self.config.paymentTypeConfig == nil {
            await self.config.paymentTypeConfig = .init(usingBonusAmount: 0, paymentType: "cash")
        }

        await self.config.paymentTypeConfig?.paymentType = type ?? "cash"
    }
    
    @MainActor
    func clear() async {
        await self.config.clearOptions()
        await self.config.clearPaymentType()
        await self.config.route = []
        await self.notifyDidClearConfig()
    }
    
    @MainActor
    func clearRoute() async {
        await self.config.route = []
        await self.notifyDidUpdatRoute()
    }

    func addListener(_ listener: TaxiOrderConfigProviderDelegate) async {
        if self.listeners.contains(listener) {
            return
        }
        debugPrint("TaxiOrderConfigProvider", "Listener", listener.self)
        self.listeners.add(listener)
    }

    func removeListener(_ listener: TaxiOrderConfigProviderDelegate) async {
        debugPrint("TaxiOrderConfigProvider", "Remove", listener.self)
        self.listeners.remove(listener)
    }

    func notifyDidUpdateConfig() async {
        for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
            await listener.didUpdateConfig(config)
        }
    }

    func notifyDidClearConfig() async {
        for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
            await listener.didClearConfig()
        }
    }
    
    func notifyDidUpdatRoute() async {
        for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
            await listener.didUpdateRoute(config.route)
        }
    }
    
    func notifyDidUpdateTariffs() async {
        for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
            await listener.didUpdateTariffs(config.tariffs)
        }
    }
    
    func notifyDidUpdateTariffOptions() async {
        for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
            await listener.didUpdateTariffOptions(self.config.tariffConfig?.options ?? [])
        }
    }
    
    func notifyDidUpdateSelectedTariff() async {
        for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
            await listener.didUpdateSelectedTariff(self.config.selectedTariff)
        }
    }
    
    func notifyDidUpdateFromLocation() async {
        for listener in listeners.allObjects.compactMap({ $0 as? TaxiOrderConfigProviderDelegate }) {
            await listener.didUpdateFrom(self.config.from)
        }
    }
}

extension TaxiOrderConfigProvider {
    @MainActor
    func setRoute(list route: [GRoutePoint]) async {
        await self.config.route = route
        await self.notifyDidUpdatRoute()
        await self.notifyDidUpdateConfig()
    }
    
    @MainActor
    func appendRoute(_ point: GRoutePoint) async {
        await self.config.route.append(point)
        await self.notifyDidUpdatRoute()
        await self.notifyDidUpdateConfig()
    }
    
    @MainActor
    func appendRoute(address point: SelectAddressItem) async {
        await self.config.route.append(.init(id: point.id, order: self.config.route.count, location: point.coordinate, address: point.address))
        await self.notifyDidUpdatRoute()
        await self.notifyDidUpdateConfig()
    }
    
    @MainActor
    func editRoute(at index: Int, with point: GRoutePoint) async {
        await self.config.route[index] = point
        await self.notifyDidUpdatRoute()
        await self.notifyDidUpdateConfig()
    }
}
