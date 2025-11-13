//
//  User+Mock.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import YallaKit

extension UserInfo {
    static var mock: YallaKit.UserInfo {
        .init(id: 101,
              phone: "998935852415",
              givenNames: "Muhammadjon",
              surName: "Tohirov",
              block: false,
              orderCount: 4,
              balance: 5000,
              busyBalance: 0,
              blockNote: nil,
              rating: "4",
              blockDate: nil,
              blockSource: nil,
              image: "https://cdn-api.ildam.uz/images/841761914171.jpg",
              blockExpiry: nil,
              services: [],
              createdAt: "18.02.2025 16:59",
              lastActivity: nil,
              birthday: "18.09.1995",
              gender: "MALE"
        )
    }
}
