//
//  Navigator.swift
//  YallaDriver
//
//  Created by applebro on 03/06/25.
//

import Foundation
import SwiftUI

final public class Navigator: ObservableObject, @unchecked Sendable {
    @MainActor public static let shared = Navigator()
    public let id: UUID = .init()
    
    @Published public var path: NavigationPath = .init()
    
    public init(path: NavigationPath) {
        self.path = path
    }
    
    public init() {
        
    }
    
    public func push(_ destination: (any SceneDestination)?) {
        debugPrint("Push to destination")
        if let destination {
            path.append(destination)
        }
    }
    
    public func pop() {
        debugPrint("Pop from destination")
        if path.isEmpty { return }
        path.removeLast()
    }
    
    public func popToRoot() {
        debugPrint("Pop to root")
        pop(by: path.count)
    }
    
    public func pop(by count: Int) {
        debugPrint("Pop by index")
        if path.count < count { return }
        path.removeLast(count)
    }
}

public protocol SceneDestination: Hashable {
    associatedtype Scene: View
    
    @MainActor
    var scene: Scene {get}
}
