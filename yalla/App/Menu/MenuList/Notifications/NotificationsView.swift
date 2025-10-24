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
            title: "news.and.notifs".localize,
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
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
        })
        .overlay(content: {
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "")
        })
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("news.and.notifs".localize)
    }
    
    private var notificationListView: some View {
        LazyVStack(spacing: 20) {
            ForEach(viewModel.notifications) { notif in
                NotificationItemView(
                    imageUrl: notif.image ?? "",
                    date: notif.date,
                    title: notif.title,
                    descr: "",
                    isRead: notif.isRead
                )
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
//    UserSettings.shared.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiMzM0NTllNWJhMzYxNjBlYjAyZTc4MGMwZDkwMWI0OTM0YTExMzJkZjA2ZWZkMzJmNWYyZjQ1MmRmOGIyMmI2MTlkYjMzZDIzYTU2ZmQyNTkiLCJpYXQiOjE3NDQ4NzU4ODUuOTE0ODI5LCJuYmYiOjE3NDQ4NzU4ODUuOTE0ODMxLCJleHAiOjE3NzY0MTE4ODUuOTA4NTgsInN1YiI6IjI0MjAzNSIsInNjb3BlcyI6WyJjbGllbnQiXX0.eTkG-iZYxU0tCZGsZS6VD4NlUeTRP4bYKfwrQv_YLiQJ0ma_9y5pgDaZ4yr0QX2P_GyiVMnyYAeVSc18sE3rfpeQbJfXe50L3rry9YSWza-ZhQFKodD0WtJ4aUqwOvQjLVeYOQUb0YFgfY2nCrGZqX5q2IiX7Coq9injWHz_l47FpPKhWsc8vtcbhF9O4u3CiB9sIMX6k5yrNxhGF3p93073Kf3A-zOZg-ADX5rsktR22eaHbJXCgp-xfMkX94m7fm55TmhO7YGoreyoSg9TwBWEZD-FJGPVcFDnnJ2w7BA6X0QmrSzhhgIk00flDLrT1-IyHoResBdoDMIcvYMYF2S0whoJEZbNxLM38Ju5_VuVyj6dVvIuw2I3J2EtkE7vmtRLXn_XY7YYp0FsvvKNws3Zo_zsyQFEf28jzxNQT8nPq3NsLbSyBqNp-1KGn_3f6zKLhQ2vztQNEJp_tmCvEVa-t7K1o-E-_U70Trqj2Fzo9Z-kGOqWqyt_9I2nbPob1HVy2PngMLLUPeo3joRD4YHyMSatZAgey_E5o6b6w_nH3eFXekQtja1176_bXj1aBqsL7LuDUtyt_np9faPM9zcvs6wMhC1FYshW47OD0qJaS9EO5SzwKpwc7HTTd4OmTvv-cI6aJEdjBnZBWrZ3KBchvL7ws9ZxZ2h_lgkYeFA"
//    UserSettings.shared.setupForTest()
//    return NotificationsView()
}
