//
//  NotificationDetailsView.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 22/04/25.
//

import SwiftUI
import IldamSDK
import YallaUtils
import Core

public struct NotificationDetailsView: View {
    var notificationId: Int
    @State
    private var notificationData: NotifItem?
    
    public var body: some View {
        Group {
            if let notificationData {
                NotificationItemView(
                    imageUrl: notificationData.image ?? "",
                    date: notificationData.date,
                    title: notificationData.title,
                    descr: notificationData.content
                )
                .scrollable(axis: .vertical)
            } else {
                ProgressView()
            }
        }.task {
            await loadNotifData()
        }
        .navigationTitle("news.and.notifs".localize)
    }
    
    private func loadNotifData() async {
        guard let item = try? await ShowAndReadNotifUseCase().execute(notifId: notificationId) else { return }
        self.notificationData = .init(item)
    }
}
#Preview {
    NotificationDetailsView(notificationId: 0)
}

