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
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("news.and.notifs".localize)
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
    UserSettings.shared.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiOTEwNTI4MTRhMGMyZGIzMzJhMDEzNGQ0MDZmMjdiNjUwMTk0NjY0OTM0NWVkNWMwMWU3NGFmMjhhMTY1MWRhMzgyZmMwNzE5MzhiMmExMWIiLCJpYXQiOjE3NjEzMDMxOTEuNzMyNTE4LCJuYmYiOjE3NjEzMDMxOTEuNzMyNTIsImV4cCI6MTc5MjgzOTE5MS43MjgzODYsInN1YiI6IjU5OTgiLCJzY29wZXMiOlsiY2xpZW50Il19.kuDDavJIR1IhTNE7Sj32qOs1WpU9wjR3uOaLIZ-GOya6LzjfB1zyuoj-38D-d8Dyot-PrINqD_7q7Rc9BxQaIlhpPbq07F01G19pw_nEU0mp3OvRhP8M0nzLsd0eGpHJg0E95DrIkaMcZu692EIC3LJN0SbaAqBuLa9xShhWPYJ4Un21D14FYI8a50PruhYE04tphJp9SBumJMleyau-Pr2lVAxkHOR2QQrMQzFw_nlQ9Bqs2E_51HuEjhdDwI1ss_py9h5EdrKvkyvh_b-2QOzN1jdgNzLJ_FPs5PtFKvNPgyK18femuRp2smtPssDAhccRuVwkhrqVIWICWeDONAX6h4aZmLJCxq_PA0Gk2Mc89HZFNwNE2j80838TZhJzERCmkB5V7MQmbCQrnEDQ5qHa_sxRMv8ZfGnjWhG27fjmL_bQO-Y-pO85X_EWBUCYL0nO11jODp45eT6Z9Q5MVfTUzIC7D614v6XeV3TwImyI4egM9_0QkKmfE-cj13i8y9nqu9RLMeKuvM5ftyZqRBzcul4uo8lgrFOAnP2nsxcDzC8r1NYAgmhRMgQBDIsw1fMnKMsueGl_VrGNy3tSlehT19WOmsN5s0nMPye5lrY87gpIctC8ZqwZl7H1UiBwcWEImV5TenhL6XBHRRVPnv9RVVhudeAuldK1lt079Is"
    UserSettings.shared.setupForTest()
    return NotificationsView()
}
