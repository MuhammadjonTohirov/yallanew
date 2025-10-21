//
//  File.swift
//  NetworkMonitor
//
//  Created by Muhammadjon Tohirov on 14/10/25.
//

import Foundation
import UIKit

public extension UIApplication {
    static let networkSatisfied: NSNotification.Name = .networkSatisfied
    static let networkLost: NSNotification.Name = .networkLost
}

public extension NSNotification.Name {
    static let networkSatisfied: NSNotification.Name =
        .init("networkSatisfied")
    
    static let networkLost: NSNotification.Name =
        .init("networkLost")
}

