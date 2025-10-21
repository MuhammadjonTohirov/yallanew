//
//  MainViewModel.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import SwiftUI
import Combine
import NetworkMonitor
import Core
import YallaUtils

protocol MainViewRouter: ObservableObject {
    func navigate(to destination: AppDestination)
    func showNetworkFailure() async
    func showServerFailure() async
}

var mainModel: (any MainViewRouter)?

enum AppPresentableRoute: @MainActor ScreenRoute, Hashable {
    var id: String {
        "\(self)"
    }
    
    case serverFailure(_ onRetry: () -> Void)
    
    var screen: some View {
        switch self {
        case .serverFailure:
            EmptyView()
        }
    }
    
    static func == (lhs: AppPresentableRoute, rhs: AppPresentableRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class MainViewModel: MainViewRouter {
    @Published var route: AppDestination = .loading
    
    @MainActor
    var present: AppPresentableRoute? {
        didSet {
            presentServerFailure = present != nil
        }
    }
    
    @Published var language: String = UserSettings.shared.language ?? LanguageUz().code
    @Published var presentNetworkFailure = false {
        didSet {
            Logging.l("presentNetworkFailure: \(presentNetworkFailure)")
        }
    }
    
    @Published var presentServerFailure = false {
        didSet {
            Logging.l("presentServerFailure: \(presentServerFailure)")
        }
    }
    
    init(route: AppDestination = AppDestination.loading) {
        self.route = route
        Logging.l("AccessToken \(UserSettings.shared.accessToken?.nilIfEmpty ?? "no-token")")
    }
    
    func set(language: any LanguageProtocol) {
        UserSettings.shared.language = language.code
        self.language = language.code
    }
}

extension MainViewModel {
    func navigate(to destination: AppDestination) {
        Task { @MainActor in
            self.route = destination
        }
    }
}

extension MainViewModel {
    @MainActor
    func showNetworkFailure() {
        self.presentNetworkFailure = true
    }
    
    @MainActor
    func showServerFailure() {
        self.present = nil
    }
    
    private func closeNetworkFailure() {
        Task {@MainActor in
            self.presentNetworkFailure = false
        }
    }
    
    @MainActor
    func showServerFailure(onRetry: @escaping () -> Void) {
        self.present = .serverFailure(onRetry)
    }
}

extension MainViewModel: NetworkMonitorDelegate {
    func networkMontior(_ model: NetworkMonitor, stateChanged isConnected: Bool) {
        Logging.l(tag: "NetworkMonitor", isConnected ? "Connected" : "Disconnected")
        Task { @MainActor in
            if isConnected {
                closeNetworkFailure()
                NotificationCenter.default.post(name: .networkSatisfied, object: nil)
                return
            }
            
            NotificationCenter.default.post(name: .networkLost, object: nil)
            showNetworkFailure()
        }
    }
}

var isMockEnvironment: Bool {
    return ProcessInfo.processInfo.environment["mock"]?.lowercased() == "yes"
}
