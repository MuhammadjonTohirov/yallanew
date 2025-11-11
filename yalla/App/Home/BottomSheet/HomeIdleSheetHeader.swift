//
//  HomeIdleSheetHeader.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

struct HomeIdleHeaderCustomInput: HomeIdleSheetHeader.Input {
    var image: String
    var title: String
    
}

struct HomeIdleHeaderTaxi: HomeIdleSheetHeader.Input {
    var image: String = "img_car_left"
    
    var title: String = "taxi".localize
}

struct HomeIdleSheetHeader: View {
    protocol Input {
        var image: String {get}
        var title: String {get}
    }
    
    @State
    var input: HomeIdleSheetHeader.Input
    
    @State
    private var offset: CGFloat = -6
    
    @State
    private var opacity: CGFloat = 0.5
    
    var body: some View {
        HStack(alignment: .center, spacing: 4.scaled) {
            ZStack {
                Circle()
                    .fill(LinearGradient(stops: [
                        .init(color: .iIconSubtle, location: 0),
                        .init(color: .init(hex: "#f9f9f9"), location: 1)
                    ], startPoint: .leading, endPoint: .trailing))
                    .frame(width: 32.scaled, height: 32.scaled)
                    .horizontal(alignment: .leading)
                
                Image(input.image)
                    .resizable()
                    .frame(width: 42.scaled, height: 30.scaled)
                    .offset(x: offset)
                    .opacity(opacity)
                    .animation(.spring, value: offset)
                    .animation(.spring, value: opacity)
                    .mask {
                        Capsule()
                            .frame(width: 42.scaled, height: 30.scaled)
                    }
            }
            .frame(width: 45.scaled, height: 32.scaled)

            Text(input.title)
                .font(.titleBaseBold)
            
            Spacer()
        }
        .id(input.image)
        .onAppear {
            offset = 0
            opacity = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.input = HomeIdleHeaderCustomInput(image: "img_mail_left", title: "mail".localize)
            }
        }
    }
}

#Preview {
    HomeIdleSheetHeader(
        input: HomeIdleHeaderTaxi()
    )
}

extension HomeIdleSheetHeader.Input {
    
}
