//
//  ProcessInfo.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation

actor ProcessInfoEnvironemnt {
    static var isMockEnabled: Bool {
        ProcessInfo.processInfo.environment["isMock"]?.lowercased() == "yes"
    }
}
