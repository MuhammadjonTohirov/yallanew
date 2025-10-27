//
//  NotificationCard.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 24/10/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Core

struct NotificationCard: View {
    var notification: NotifItem
    
    var body: some View {
        HStack(spacing: 0) {
            leadingReadIndicator(for: notification)
            content(for: notification)
                .padding(.all)
        }
        .background(cardBackground(isRead: notification.isRead))
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func leadingReadIndicator(for notification: NotifItem) -> some View {
        if !notification.isRead {
            UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 25,
                topTrailingRadius: 25
            )
            .fill(Color.iPrimary)
            .frame(width: 3, height: 70)
        }
    }

    @ViewBuilder
    private func content(for notification: NotifItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            header(for: notification)
            Divider()
            Text(notification.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
            Text(notification.content)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.black)
                .lineLimit(3)
        }
    }

    @ViewBuilder
    private func header(for notification: NotifItem) -> some View {
        HStack {
            Text(notification.type ?? "")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
            Spacer()
            Text(notification.date)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.primary)
        }
    }

    private func cardBackground(isRead: Bool) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(!isRead ? Color.iBackgroundSecondary : Color.background)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(UIColor.secondarySystemBackground), lineWidth: 2)
        )
    }
}

#Preview {
    NotificationCard(notification: NotifItem(
        id: 0,
        title: "Сегодня −20% на все поездки утром!",
        type: "Акции",
        date: "30 Апрель, 2022",
        content: "Сегодня −20% на все поездки утром! Успейте воспользоваться.Акция: скидка 20% до 11:00.",
        isRead: false) )
}
