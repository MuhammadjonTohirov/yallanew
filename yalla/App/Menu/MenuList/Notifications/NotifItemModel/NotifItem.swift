//
//  NotifItem.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 24/10/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Core

final class NotifItem: Identifiable {
    let id: Int
    let title: String
    let type: String?
    let date: String
    let content: String
    var image: String?
    var isRead: Bool
    
    init(id: Int, title: String, type: String,date: String, content: String, isRead: Bool) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.content = content
        self.isRead = isRead
    }
    
    init(_ item: NotificationItem) {
        self.id = item.id ?? 0
        self.title = item.title ?? ""
        self.type = item.type ?? "news.and.notifs".localize
        self.date = Date(timeIntervalSince1970: Double(item.createdAt ?? 0)).toExtendedString(format: "dd.MM.yyyy. HH:mm")
        self.content = item.content ?? ""
        self.image = item.image
        self.isRead = item.readed ?? false
    }
}

enum NotificationsRoute: @MainActor ScreenRoute {
    
    var id: String {
        "\(self)"
    }
    
    case details(id: Int)
    
    var screen: some View {
        switch self {
        case .details(let id):
            NotificationDetailsView(notificationId: id)
        }
    }
}
