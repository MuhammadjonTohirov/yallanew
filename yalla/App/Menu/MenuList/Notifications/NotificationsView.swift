//
//  NotificationsView.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 21/04/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Core

struct NotificationsView: View {
    @StateObject
    var viewModel: NotificationsViewModel = .init()
    
    var body: some View {
        PageableScrollView(
            title: "".localize,
            onReachedBottom: {
                Task {
                    await viewModel.loadNotificationsIfCan()
                }
            },
            content: {
                if viewModel.hasNotifications {
                    emptyNotificationsView
                } else {
                    notificationListView
                }
            }
        )
        .appSheet(
            isPresented: $viewModel.showBottomSheet,
            title: "news.and.notifs".localize
        ) {
            if let notificationId = viewModel.selectedNotificationId {
                NotificationDetailsView(notificationId: notificationId)
            }
        }
        .overlay(content: {
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "")
        })
        
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("news.and.notifs".localize)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.markAllAsRead() }
                }
                label: {
                    Image("icon_check_circle")
                         .resizable()
                         .frame(width: 32, height: 32)
                         .disabled(!viewModel.hasUnread || viewModel.isLoading)

                }
            }
            .sharedBackgroundVisibility(visible: false)
        })
    }
    
    private var notificationListView: some View {
        LazyVStack(spacing: 20) {
            ForEach(viewModel.notifications) { notif in

                NotificationCard(
                    notification: NotifItem(
                        id: notif.id,
                        title: notif.title,
                        type: notif.type ?? "",
                        date: notif.date,
                        content: notif.content,
                        isRead: notif.isRead
                    ))
                .onTapGesture {
                    viewModel.showNotificationDetails(notif.id)
                }
            }
        }
        .padding(.top, Padding.default)
    }
    
    private var emptyNotificationsView: some View {
        VStack(spacing: 5) {
            Circle()
                .frame(height: 166)
                .foregroundStyle(Color.background)
                .overlay {
                    Image("new_img_no_notifs")
                        .resizable()
                        .frame(width: 110, height: 110)
                }
            Text(verbatim: "no.notifs.descr".localize)
                .multilineTextAlignment(.center)
                .font(.inter(.light, size: 14))
                .foregroundStyle(Color.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 70.f.sh())
    }
}

#Preview {
    UserSettings.shared.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiMzgwZjk1Yjk2NTE3Nzg2ZjgzNWFkNzk3N2E5ZTdjNDQ1ZDFiMThjN2IxYmVhZjVjNjBkNjEyNGZhNWM0ZGI2NzkzNjhlMWJiZTZiYzA0NTAiLCJpYXQiOjE3NjE1NjAzMDcuNTgxOTEyLCJuYmYiOjE3NjE1NjAzMDcuNTgxOTE1LCJleHAiOjE3OTMwOTYzMDcuNTc4NDk0LCJzdWIiOiI1OTk4Iiwic2NvcGVzIjpbImNsaWVudCJdfQ.AlS8KYLeW55vM6A-4Z1c9wWwVj6ohlHo3_16LuemDA1yGaUht5t1vroUczW9rEoJvW2uvCfxtLonX1rMPJYuRBZeZ_ZuFOC0lhRBoYBe8-Fzuev1DHjibZfM168tvjYlKf_OIYUGsfURbwN4-H_gjLh7hn5v2OXCQlWS-bmd61G2jixWC1aIdPdOIpUerZFEZzvZ_dS6FouKh0xr2ZEsuUrvxwxt5Y14n2fUwQUQOVejWyKk54SgqjWL8gaAnI3SCsC5DfGYCbKziVofxhJhC6W31stf2FfEZj0-yp86aPoHASgQttoaNG_MVA5FYTf-0AVTtaoxFJuUz8WJAw5Bk2l9A64wTXLB6pR13VKlviGl3xTHJTCRzLRrtNHBn1dvxkBfZlgskerO83wCVOYlDRt5D4TkL0w-pVFJdWzcF4Z9H0-6dEisiClbnlhp5nV5V1LlqAPxSPkq6OcjI9PtEpdzLSoNmIlA9okDTjd8N8lKDLIDDWFZaDw38zSyJMqtDrZJWgJaUu9-WXrJ9dmGwXFrpZsvd3VE77owBZMCd0H_5Se7hMC4qY1jeYRpqwLvzP2IxWvgkY4sYw_sh1VGF2wk28VRP1ypAPGWSCS0oxXucZDfbD9yGT1jckBRW9hCXYPRGxH33foXHkk5jf6-0WuyiKABd4t6VoQ9Hofvq0U"
    UserSettings.shared.setupForTest()
    return NavigationView {
        NotificationsView()
    }
}
