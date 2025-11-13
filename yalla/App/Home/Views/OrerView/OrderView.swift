//
//  OrderView.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 10/11/25.
//

import SwiftUI
import Core
import YallaUtils

struct OrderView: View {
    @State private var progress: Double = 0.55
    @State private var showOrderInfo: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView
            
            progressView
            
            middelSection
 
            cancelOrder
        }
        .padding(.horizontal)
    }
    
    
    private var headerView: some View {
        VStack(alignment: .leading,spacing: 12) {
           VStack (alignment: .leading,spacing: 6) {
                Text("cars.nearby".localize(arguments: 4))
                    .font(.bodyLargeBold)
                    .foregroundColor(.iLabel)
               
                Text(verbatim: "Выбираем подходящие".localize(arguments: 4))
                    .font(.bodySmallMedium)
                    .foregroundColor(.iLabel)
            }
            
            Divider()

        }
    }
    private var progressView: some View {
        VStack(spacing: 12) {
           HStack {
                Text("process.may.take.minutes".localize(arguments: 2))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.iLabel)
               
               Spacer()
               Text("11:33")
                   .font(.system(size: 14, weight: .medium))
                   .foregroundColor(.iLabel)

            }
            
            FlowProgressView(
                progress: progress,
                fillGradient: LinearGradient(
                    colors: [.red, .iPrimaryDark],
                    startPoint: .leading, endPoint: .trailing
                ), trackColor: .iBackgroundSecondary,
                stripeColor: .iBackgroundSecondary.opacity(0.20)
            )
            .frame(height: 16)
        }
    }
    private var middelSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SubmitButton(backgroundColor: Color.background) {
                HStack(spacing: 10) {
                    Image.icon("icon_add_circle")
                        .aspectRatio(contentMode: .fill)
                            
                    Text(verbatim: "Заказать еще")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.iLabel)
                    
                    Spacer()
                    
                    Image.icon("icon_arrow_right")
                       
                }
                .padding(.horizontal)
            }
            action: {
                
            }
            .background(
                RoundedRectangle(cornerRadius: AppParams.Radius.default)
                    .stroke(lineWidth: 3)
                    .foregroundStyle(Color.iBorderDisabled)
            )
            
            SubmitButton(backgroundColor: Color.background) {
                HStack(spacing: 10) {
                    Image.icon("icon_info_circle")
                        .aspectRatio(contentMode: .fill)
                            
                    Text("Информация о поездке")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.iLabel)
                    
                    Spacer()
                    
                    Image.icon("icon_arrow_right")
                    
                }
                .padding(.horizontal)

            }
            action: {
                
            }
            
            .background(
                RoundedRectangle(cornerRadius: AppParams.Radius.default)
                    .stroke(lineWidth: 3)
                    .foregroundStyle(Color.iBorderDisabled)
            )
        }
     }
    private var cancelOrder: some View {
        VStack {
             
            SubmitButton(
                backgroundColor: Color.iButtonTertiary, pressedColor: Color.iButtonTertiaryDisabled,
                height: 60) {
                    HStack(spacing: 10) {
                        
                        Image.icon("icon_close_circle", color: Color.background)
                            .aspectRatio(contentMode: .fit)
 
                        Text("Отменить заказ")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.background)
                    }

                } action: {
                    
            }
        }
    }

}

#Preview {
    OrderView()
}
