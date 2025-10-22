//
//  HomeServicesCard.swift
//  yalla
//
//  Created by OpenAI on 24/10/25.
//

import SwiftUI
import Core
import YallaUtils

struct HomeServicesCard: View {
    struct Service: Identifiable, Equatable {
        let id: UUID
        let title: String
        let backgroundImageName: String
        
        init(
            id: UUID = UUID(),
            title: String,
            backgroundImageName: String
        ) {
            self.id = id
            self.title = title
            self.backgroundImageName = backgroundImageName
        }
    }
    
    let services: [Service]
    var onServiceSelected: ((Service) -> Void)?
    
    private let cardGradient = LinearGradient(
        colors: [.iPrimaryLite, .iPrimaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    init(
        services: [Service],
        onServiceSelected: ((Service) -> Void)? = nil
    ) {
        self.services = services
        self.onServiceSelected = onServiceSelected
    }
    
    var body: some View {
        HStack(spacing: 10.scaled) {
            ForEach(services) { service in
                serviceButton(for: service)
            }
        }
    }
    
    private func serviceButton(for service: Service) -> some View {
        Button {
            onServiceSelected?(service)
        } label: {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20.scaled, style: .continuous)
                    .fill(cardGradient)
                
                Image(service.backgroundImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 114.scaled, height: 120.scaled)
                    .clipped()

                Text(service.title)
                    .font(.bodySmallBold)
                    .foregroundStyle(Color.white)
                    .padding(.top, AppParams.Padding.default.scaled)
                    .padding(.leading, 12.scaled)
            }
            .cornerRadius(20.scaled, corners: .allCorners)
            .frame(width: 114.scaled, height: 120.scaled)
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
#Preview {
    HomeServicesCard(
        services: [
            .init(title: "Межгород", backgroundImageName: "img_bg_intercity"),
            .init(title: "Почта", backgroundImageName: "img_bg_post"),
            .init(title: "Доставка", backgroundImageName: "img_bg_delivery")
        ],
        onServiceSelected: { _ in }
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
#endif
