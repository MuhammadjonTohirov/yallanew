//
//  NetworkReachable.swift
//  YuzSDK
//
//  Created by applebro on 03/06/24.
//

import Foundation
import Network
import SwiftUI

public enum NetworkIntensivity: Identifiable, EnvironmentKey {
    nonisolated(unsafe) public static var defaultValue: NetworkIntensivity = .loading

    public typealias Value = NetworkIntensivity

    public var id: String {
        switch self {
        case .connected: return "connected"
        case .disconnected: return "disconnected"
        case .loading: return "loading"
        }
    }

    case connected
    case disconnected
    case loading
}

