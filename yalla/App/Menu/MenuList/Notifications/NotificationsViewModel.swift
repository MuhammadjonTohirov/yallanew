//
//  NotificationsViewModel.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 21/04/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Core
import Combine

final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotifItem] = []
    @Published var isLoading: Bool = false
    private var hasNextPage: Bool = true
    @Published var push: Bool = false
    @Published var showBottomSheet: Bool = false
    @Published var selectedNotificationId: Int?
    
    var route: NotificationsRoute? {
        didSet {
            push = route != nil
        }
    }

    var hasNotifications: Bool {
        !hasNextPage && notifications.isEmpty
    }
    
    var page: Int = 1
    var perPage: Int = 10
    
    func loadNotificationsIfCan() async {
        guard hasNextPage else { return }
        
        do {
            let list = try await LoadNotificationsUseCase().execute(page: page, perPage: perPage)
            self.hasNextPage = list?.list?.isEmpty == false
            await MainActor.run { [weak self] in
                self?.set(list: list?.list ?? [])
            }
            if hasNextPage {
                page += 1
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @MainActor
    private func set(list: [NotificationItem]) {
        self.notifications += list.map(NotifItem.init)
    }
    
    @MainActor
    func showLoading() {
        isLoading = true
    }
    
    @MainActor
    func hideLoading() {
        isLoading = false
    }
    
    func showNotificationDetails(_ id: Int) {
        self.notifications.first(where: {$0.id == id})?.isRead = true
        self.selectedNotificationId = id
        self.showBottomSheet = true
    }
}

