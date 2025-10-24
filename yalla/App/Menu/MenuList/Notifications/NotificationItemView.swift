//
//  NotificationListItem.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 21/04/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Core
import Kingfisher


struct NotificationItemView: View {
    var imageUrl: String
    var type: String?
    var date: String
    var title: String
    var descr: String
    var isRead: Bool = true
    
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: 6) {
                
                header
                footer
            }
        })
        .padding(.horizontal, 20)
    }
    
    private var imageView: some View {
        KFImage(.init(string: imageUrl))
            .placeholder {
                Image("img_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 105, height: 72, alignment: .center)
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .background(.iLabelSubtle)
            .frame(height: 180, alignment: .center)
            .cornerRadius(16)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            DismissCircleButton()
                .padding(.bottom, 15)
            imageView
            
            HStack {
                Text(type ?? "permissions.notification.title".localize)
                    .font(.inter(.bold, size: 16))
                    .foregroundStyle(.iLabel)
                    .padding(.top, 4)
                Spacer()
                
                Text(date)
                    .font(.inter(.light, size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            
            Divider()
        }
    }
    
    private var footer: some View {
        
       VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .multilineTextAlignment(.leading)
                .font(.inter(isRead ? .bold : .semibold, size: 20))
            
            Text(descr)
                .font(.inter(.light, size: 14))
                .foregroundStyle(Color.secondary)
                .visibility(!descr.isEmpty)
        }
    }
}

#Preview {
    NotificationItemView(
        imageUrl: "https://fastly.picsum.photos/id/47/300/200.jpg?hmac=9EsCkmRWNWNcad1bCkYlIyvrH7KYONvdKRbWChvJ-Us",
        date: "21/04/2025 21:02",
        title: "Lorem ipsum dolor sit amet",
        descr: """
            Начни день выгодно! Только сегодня с 7:00 до 11:00 действует специальная акция – скидка 20% на все поездки через наше такси.Неважно, куда ты собираешься: — на работу или учёбу, — на важную встречу, — или просто по делам — с нами ты доедешь быстрее, комфортнее и дешевле. Мы заботимся о том, чтобы твое утро началось с удобства: ✔️ быстрый вызов машины, ✔️ надежные водители, ✔️ приятная цена со скидкой.Скидка применяется автоматически при заказе, никаких промокодов не нужно. Успей воспользоваться предложением — оно действует только сегодня утром!
            """
    )
}
