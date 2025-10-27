//
//  AboutApplicationView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 27/10/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

struct AboutApplicationView: View {
    @Environment(\.dismiss) var dismiss
    @State
    private var startPoint: UnitPoint = .topLeading
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .iPrimaryLite.opacity(1), location: 0),
                .init(color: .iPrimaryDark.opacity(1), location: 1),
            ], center: startPoint, startRadius: 0, endRadius: 300)
            .ignoresSafeArea()
            
            VStack {
                headerView
                    
                containView
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            
            Image("splash_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 100)
                Spacer()
            
            VStack(spacing: 8) {
                Text("yalla".localize)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Version: 1.21")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .frame(height: 280)
        .padding(.bottom,20)
     }
    
    private var footer: some View {
        VStack(alignment: .leading) {
            
            Text("О приложении")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.iLabel)
                .padding(.vertical)
            
           VStack(spacing: 0) {
                rowItem(title: "Политика конфиденциальности")
               Divider()
                rowItem(title: "Лицензионное соглашение")
            }
           .background(
               RoundedRectangle(cornerRadius: 16)
                   .fill(Color(UIColor.iBackgroundSecondary))
           )
           .padding(.horizontal,5)

            
            Text("Мы в социальных сетях")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.iLabel)
                .padding(.vertical)

            VStack(spacing: 0) {
               
                rowItem(
                    icon: "image_instagramm",
                    title: "Instagram")
                
                Divider()
                
                rowItem(icon: "image_telegramm",title: "Telegram")
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.iBackgroundSecondary))
            )
            .padding(.horizontal,5)

            Spacer()
            
            SubmitButton(backgroundColor: Color.iPrimary, height: 60) {
                Text("Оценить приложение")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading)
            }
            action: {
                
            }
            .padding(.horizontal,5)
            .padding(.vertical)


        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    private var containView: some View {
        Rectangle()
            .transition(.push(from: .bottom).combined(with: .identity))
            .foregroundStyle(Color.background)
            .cornerRadius(40, corners: [.topLeft, .topRight])
            .overlay(content: {
                footer
            })
            .ignoresSafeArea()
        
    }
    
    func rowItem(icon: String? = nil, title: String) -> some View {

        HStack(spacing: 12) {
            if let icon = icon {
                Image(icon)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .animation(nil, value: UUID())
    }
}

#Preview {
    AboutApplicationView()
}
