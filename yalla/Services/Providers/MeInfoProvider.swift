//
//  MeInfoProvider.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 29/10/25.
//

import Foundation
import YallaKit
import Core
import Combine
import CoreLocation

protocol MeInfoProviderProtocol {
    // Make the getter async so actor conformers are valid and callers must await.
    var userInfo: YallaKit.UserInfo? { get async }
}

final actor MeInfoProvider: NSObject, MeInfoProviderProtocol {
    static let shared: MeInfoProvider = .init()
    
    var userInfo: YallaKit.UserInfo?
    
    private(set) var userInfoChangeSubject: PassthroughSubject<YallaKit.UserInfo?, Never> = .init()
    
    func setUserInfo(_ userInfo: YallaKit.UserInfo?) {
        self.userInfo = userInfo
        UserSettings.shared.userInfo = userInfo
        userInfoChangeSubject.send(userInfo)
    }
    
    @discardableResult
    func syncUserInfo() async throws -> YallaKit.UserInfo? {
        let info = await AuthService.shared.getUserInfo()
        setUserInfo(info?.userInfo)
        return info?.userInfo
    }
}
